package com.javalec.mybbs.dto;

import java.sql.Date;

public class AttachDto {
	private int attachId;
	private String fullName;
	private String userId;
	private Date regDate;
	
	public int getAttachId() {
		return attachId;
	}
	public void setAttachId(int attachId) {
		this.attachId = attachId;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	
}
