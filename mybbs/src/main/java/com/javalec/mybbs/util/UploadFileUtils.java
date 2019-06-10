package com.javalec.mybbs.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;
import org.springframework.util.FileCopyUtils;

public class UploadFileUtils {
	
	public static String uploadFile(
			String uploadPath, String originalName, byte[] fileData )
			throws Exception {
		UUID uid = UUID.randomUUID();
		String saveName = uid.toString() + "_" + originalName;
		
		//서버에 파일 올림
		File target = new File(uploadPath, saveName);
		
		//원하는 디렉토리에 복사
		FileCopyUtils.copy(fileData, target);
		
		String formatName = originalName.substring(originalName.lastIndexOf(".")+1);
		String uploadedFileName = null;
		if(MediaUtils.getMediaType(formatName)!=null) {
			uploadedFileName = makeThumbnail(uploadPath,saveName);
		} else {
			uploadedFileName = makeIcon(uploadPath,saveName);
		}
		return uploadedFileName;
	}

	private static String makeIcon(String uploadPath, String saveName)
			throws Exception {
		String iconName = uploadPath + File.separator + saveName;
		//File.separator : 디렉토리 구분자
		return iconName.substring(uploadPath.length()).replace(File.separatorChar, '/');
	}

	private static String makeThumbnail(String uploadPath, String saveName)
			throws Exception {
		BufferedImage sourceImg = ImageIO.read(new File(uploadPath, saveName));
		BufferedImage destImg = Scalr.resize(sourceImg, 
				Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT, 100);
		
		String thumbnailName = uploadPath + File.separator + "s_" + saveName;
		File newFile = new File(thumbnailName);
		String formatName = saveName.substring(saveName.lastIndexOf(".") + 1);
		
		//썸네일 생성
		ImageIO.write(destImg, formatName, newFile);
		
		return thumbnailName.substring(uploadPath.length())
				.replace(File.separatorChar, '/');
	}
	
	public static String makeDir(String uploadPath, String folderName) throws Exception {
		// 디렉토리가 존재하면 통과 //마지막에 들어오는 경로가 폴더명
		File dirPath = new File(uploadPath + File.separatorChar +  folderName);
		if(dirPath.exists()) { //이미 같은 이름존재
			return "";
		} else {
			dirPath.mkdirs();
			UUID uid = UUID.randomUUID();
			folderName = uid.toString() + "_" + folderName ;
			folderName = "/f_" + folderName;
			return folderName;
		}
	}
	
	public static void deleteDir(String path) throws Exception {
		// 디렉토리가 존재하면 통과 //마지막에 들어오는 경로가 폴더명
		
		File deleteFolder = new File(path);
		
		if(deleteFolder.exists()){
			File[] deleteFolderList = deleteFolder.listFiles();
			
			for (int i = 0; i < deleteFolderList.length; i++) {
				if(deleteFolderList[i].isFile()) {
					deleteFolderList[i].delete();
				}else {
					deleteDir(deleteFolderList[i].getPath());
				}
				deleteFolderList[i].delete(); 
			}
			deleteFolder.delete();
		}
		
	}

}
