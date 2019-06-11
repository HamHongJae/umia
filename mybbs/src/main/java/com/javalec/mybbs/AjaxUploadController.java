package com.javalec.mybbs;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.javalec.mybbs.dao.IAttachDao;
import com.javalec.mybbs.util.MediaUtils;
import com.javalec.mybbs.util.UploadFileUtils;

@Controller
public class AjaxUploadController {
	
	@Resource(name="uploadPath")
	String uploadPath;

	@Autowired
	private SqlSession sqlSession;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
		
	@RequestMapping(value="uploadAjax", method = RequestMethod.GET)
	public ModelAndView uploadAjax(HttpSession session, ModelAndView mav) {
		String id = (String) session.getAttribute("userId");
		if (id == null ) {
			mav.addObject("msg", "로그인해주세요");
			mav.setViewName("main");
		} else {
			mav.setViewName("/uploadAjax");
		}
		return mav;
	}
	
	@Transactional
	@RequestMapping(value="uploadAjax",  //업로드
					method = RequestMethod.POST,
					produces="txet/plain;charset=utf-8")
	public ResponseEntity<String> uploadAjax(MultipartFile file, HttpSession session) throws Exception{
		
		logger.info("OriginalFilename" + file.getOriginalFilename());
		logger.info("size" + file.getBytes());
		logger.info("ContentType" + file.getContentType());
		
		String userId = (String)session.getAttribute("userId");
		logger.info("userId :"+ userId);
		
		//파일 upload에 저장
		String savedFileName = UploadFileUtils.uploadFile(uploadPath , file.getOriginalFilename(), file.getBytes());
		//db 래코드 등록 Insert
		IAttachDao dao = sqlSession.getMapper(IAttachDao.class);
		dao.attachInsert(savedFileName,userId,uploadPath);
		
		//new ResponseEntity(데이터(업로드파일이름), 상태코드)  데이터와 상태를 돌려줌
		return new ResponseEntity<String>("saved",HttpStatus.OK);
	}
	
	@RequestMapping("/attachList") 
	@ResponseBody //첨부리스트
	public List<String> attachList(HttpSession session) {
		String userId = (String)session.getAttribute("userId");
		IAttachDao dao = sqlSession.getMapper(IAttachDao.class);
		List<String> list = dao.attachList(userId,uploadPath);
		return list;
	}
	
	
	@Transactional
	@ResponseBody 
	@RequestMapping("/displayFile") //다운로드 링크
	public ResponseEntity<byte[]> displayFile(String fileName) throws Exception {
		InputStream in = null; //스트림
		ResponseEntity<byte[]> entity = null;
		try {
			//파일 확장자 검사
			String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);
			MediaType mType = MediaUtils.getMediaType(formatName);
			
			HttpHeaders headers = new HttpHeaders();
			in = new FileInputStream(uploadPath + fileName);
			if(mType != null) { //이미지 파일인경우
				headers.setContentType(mType);
			} else {
				fileName = fileName.substring(fileName.indexOf("_")+1);
				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
				fileName = new String(fileName.getBytes("utf-8"),"iso-8859-1"); //파일이름 한글이 있는경우
				headers.add("Content-Disposition","attachment; filename=\""+fileName+"\"");
			}
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in),headers, HttpStatus.OK);
		}catch(Exception e){
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		} finally {
			if(in != null) {
				in.close();
			}
		}
		return entity;
	}
	
	@Transactional
	@ResponseBody	//삭제
	@RequestMapping(value="deleteFile", 
					method = RequestMethod.POST)
	public ResponseEntity<String> deleteFile(String fileName) throws Exception {
		
		String formatName = fileName.substring(fileName.lastIndexOf(".")+1);
		MediaType mType = MediaUtils.getMediaType(formatName);
		
		//래코드 삭제부분
		IAttachDao dao = sqlSession.getMapper(IAttachDao.class);
		dao.attachDelete(fileName);
		
		//파일삭제부분
		new File(uploadPath+fileName.replace('/', File.separatorChar)).delete();
		
		if(mType != null) { //이미지이면
			//fileName:/s_1d0cbece-4a6d-4b3a-b36a-b07e357d6212_folder.png
			fileName = "/" + fileName.substring(3);
			new File(uploadPath+fileName.replace('/', File.separatorChar)).delete();				
		}
		return new ResponseEntity<String>("deleted",HttpStatus.OK);
	}
	
	@Transactional
	@ResponseBody	//새폴더
	@RequestMapping(value="createFolder", 
					method = RequestMethod.POST)
	public ResponseEntity<String> createFolder(String folderName ,HttpSession session) throws Exception {
		String userId = (String)session.getAttribute("userId");
		
		//폴더 만들기 	
		folderName = UploadFileUtils.makeDir(uploadPath, folderName);
		if ( folderName.isEmpty() ){
			return new ResponseEntity<String>("exists",HttpStatus.OK);
		} else {
			//래코드에 폴더등록
			IAttachDao dao = sqlSession.getMapper(IAttachDao.class);
			dao.attachInsert(folderName,userId,uploadPath);
			return new ResponseEntity<String>("created",HttpStatus.OK);
		}
	}
	
	@Transactional
	@ResponseBody	//새폴더  // f_UUID_폴더명
	@RequestMapping(value="deleteFolder", 
					method = RequestMethod.POST)
	public ResponseEntity<String> deleteFolder(String folderName ,HttpSession session) throws Exception {
		
		IAttachDao dao = sqlSession.getMapper(IAttachDao.class);
		//래코드에 폴더삭제 
		dao.attachDelete(folderName);
		
		logger.info("folderName1 :"+ folderName);
		folderName = folderName.substring(folderName.lastIndexOf("_")+1);
		logger.info("folderName2 :"+ folderName);
		//래코드에서 폴더경로에 파일 삭제
		dao.locationDelete(uploadPath+"/"+folderName + "%");
		
		//실제 폴더 + 폴더안 파일 삭제
		UploadFileUtils.deleteDir(uploadPath+"/"+folderName);
		
		return new ResponseEntity<String>("deleted",HttpStatus.OK);
	}
	
	@ResponseBody	//폴더 안으로 들어가는 호출
	@RequestMapping(value = "goInfolder",
			method = RequestMethod.POST,
			produces="txet/plain;charset=utf-8")
	public ResponseEntity<String> goInfolder(String folderName) throws Exception {
		uploadPath = uploadPath + "/" + folderName;
		logger.info("uploadPath: " + uploadPath);
		return new ResponseEntity<String>(uploadPath,HttpStatus.OK);
	}
	
	@ResponseBody	//폴더 뒤로 나가는 호출
	@RequestMapping(value = "goOutfolder", 
			method = RequestMethod.POST,
			produces="txet/plain;charset=utf-8")
	public ResponseEntity<String> goOutfolder() throws Exception {
		if ( uploadPath.length() > 9 ) {
			uploadPath = uploadPath.substring(0, uploadPath.lastIndexOf("/") );
		}
		logger.info("uploadPath: " + uploadPath);
		return new ResponseEntity<String>(uploadPath,HttpStatus.OK);
	}
}
