package com.javalec.mybbs;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.javalec.mybbs.dao.IGbookDao;
import com.javalec.mybbs.dao.IUserDao;


/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@Autowired
	private SqlSession sqlSession;

	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	@RequestMapping("/index")
	public ModelAndView index(ModelAndView mav) {
		mav.addObject("msg", "환영합니다.");
		mav.setViewName("main");
		return mav;
	}
	
	@RequestMapping("/main")
	public ModelAndView main(ModelAndView mav) {
		mav.addObject("msg", "환영합니다.");
		mav.setViewName("main");
		return mav;
	}

	@RequestMapping("/fetch")
	public String fetch() {
		
		
		return "fetch/fetch";
	}
	@RequestMapping("/css")
	public String css() {
		
		return "fetch/css";
	}
	@RequestMapping("/html")
	public String html() {
		
		return "fetch/html";
	}
	@RequestMapping("/welcome")
	public String welcome() {
		
		return "fetch/welcome";
	}
	@RequestMapping("/A")
	public String A() {
		
		return "card/A";
	}
	
	@RequestMapping("/list")
	public String list() {
		
		return "fetch/list";
	}
	
	@RequestMapping("/login")
	public String login(Locale locale, Model model) {
		
		return "login";
	}
	
	@RequestMapping("/loginCheck")
	public ModelAndView loginCheck(HttpServletRequest request, HttpSession session) {
		
		String id = request.getParameter("id");
		String pw = request.getParameter("password");
		IUserDao userDao = sqlSession.getMapper(IUserDao.class);
		String name = userDao.loginCheckGetName(id,pw);	
		
		ModelAndView mav = new ModelAndView();
		if(name != null) {
			session.setAttribute("userId", id);
			session.setAttribute("userName", name);
			mav.addObject("msg", "로그인 성공");
		} else {
			mav.addObject("msg", "로그인 실패");
		}
		mav.setViewName("main");
		return mav;
	}
	
	@RequestMapping("/logout")
	public ModelAndView logout(HttpSession session) {
		session.invalidate();
		ModelAndView mav = new ModelAndView();
		mav.setViewName("login");
		mav.addObject("msg", "logout");
		return mav;
	}
	
	@RequestMapping("/sign_up")
	public String sign_up() {
		
		return "sign_up";
	}
	
	@RequestMapping("/sign_up.do")
	public String sign_up_Action(HttpServletRequest request, Model model) {
		
		IUserDao dao = sqlSession.getMapper(IUserDao.class);
		
			dao.sign_up(	
			request.getParameter("userId"),
			request.getParameter("userPassword"),
			request.getParameter("userName"),
			request.getParameter("userGender"),
			request.getParameter("userEmail")
				);
		
		return "main";
	}
	
	@RequestMapping("/idCheck")
	public String idcheck(HttpServletRequest request, Model model) {
		
		return "idCheck";
	}
	
	@RequestMapping("/idCheckDo")
	public ModelAndView idCheckDo(HttpServletRequest request, ModelAndView mav) {
		
		IUserDao dao = sqlSession.getMapper(IUserDao.class);
		String userId = request.getParameter("userId");
		mav.addObject("userId", userId );
		String CheckId = dao.idCheck(userId);
		if( CheckId != null ) {
			mav.addObject("msg", "사용 불가능한 아이디");
			mav.addObject("available", "false");
		} else {
			mav.addObject("msg", "사용 가능한 아이디");
			mav.addObject("available", "true");
		}
		mav.setViewName("redirect:idCheck");
		return mav;
	}
	
	@RequestMapping("/profile")
	public ModelAndView profile(HttpSession session, ModelAndView mav) {
		String id = (String) session.getAttribute("userId");
		
		if (id == null ) {
			mav.addObject("msg", "로그인해주세요");
			mav.setViewName("main");
		} else {
			IUserDao dao = sqlSession.getMapper(IUserDao.class);
			mav.addObject("dto",dao.viewUser(id));
			mav.setViewName("profile");
		}
		return mav;
	}
	
	@RequestMapping("/minigame")
	public String minigame() {
		return "minigame";
	}
	
	@RequestMapping("/guestBook")
	public ModelAndView guestBook(HttpSession session, ModelAndView mav) {
		String id = (String) session.getAttribute("userId");
		if (id == null ) {
			mav.addObject("msg", "로그인해주세요");
			mav.setViewName("main");
		} else {
			IGbookDao dao = sqlSession.getMapper(IGbookDao.class);
			mav.addObject("list",dao.gbookList());
			mav.setViewName("guestBook");
		}
		return mav;
	}
	@RequestMapping("/gbookList")
	public ModelAndView gbookList(HttpSession session, ModelAndView mav) {
		String id = (String) session.getAttribute("userId");
		if (id == null ) {
			mav.addObject("msg", "로그인해주세요");
			mav.setViewName("main");
		} else {
			IGbookDao dao = sqlSession.getMapper(IGbookDao.class);
			mav.addObject("list",dao.gbookList());
			mav.setViewName("fetch/gbookList");
		}
		return mav;
	}
	@RequestMapping("/more")
	public ModelAndView more(HttpSession session, ModelAndView mav) {
		String id = (String) session.getAttribute("userId");
		if (id == null ) {
			mav.addObject("msg", "로그인해주세요");
			mav.setViewName("main");
		} else {
			IGbookDao dao = sqlSession.getMapper(IGbookDao.class);
			mav.addObject("list",dao.gbookList());
			mav.setViewName("fetch/more");
		}
		return mav;
	}
	
	@RequestMapping("/gbookInsert")
	public String gbookInsert(HttpSession session, HttpServletRequest request) {
		IGbookDao dao = sqlSession.getMapper(IGbookDao.class);
		dao.gbookInsert(
				(String)session.getAttribute("userId"),
				request.getParameter("content")
				);
		return "redirect:guestBook";
	}

	@RequestMapping("/gbookDelete")
	public ModelAndView gbookDelete(HttpSession session, HttpServletRequest request, ModelAndView mav) {
		IGbookDao dao = sqlSession.getMapper(IGbookDao.class);
		String sId = (String)session.getAttribute("userId");
		String rId = request.getParameter("userId");
		if(sId.equals(rId)) {
			dao.gbookDelete(request.getParameter("gbookId"));	
			mav.setViewName("redirect:guestBook");
		} else {
			mav.addObject("msg", "타인의 글은 삭제 불가능합니다. ");
			mav.setViewName("main");
		}
		
		return mav;
	}
	
}