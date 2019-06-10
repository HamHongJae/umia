package com.javalec.mybbs;

import java.io.File;
import java.util.UUID;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class UploadController {
	
	
	@Resource(name="uploadPath")
	String uploadPath;
	
	@RequestMapping(value="upload", method = RequestMethod.GET)
	public String upload() {
		return "/upload";
	}
	@RequestMapping(value="upload", method = RequestMethod.POST)
	public ModelAndView upload(MultipartFile file, ModelAndView mav) throws Exception{
		String saveName = file.getOriginalFilename();
		saveName = uploadFile(saveName, file.getBytes());
		mav.setViewName("uploadResult");
		mav.addObject("saveName",saveName);
		return mav;
	}
	
	private String uploadFile(String originalName, byte[] fileData) throws Exception{
		UUID uid = UUID.randomUUID();
		String saveName =  uid + "_" + originalName;
		File target = new File(uploadPath, saveName);	
		FileCopyUtils.copy(fileData, target);
		return saveName;
	} 
}
