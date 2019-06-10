package com.javalec.mybbs.dto;

import java.sql.Date;

public class GbookDto {
	private String gbookId;
	private String userId;
	private Date bbsDate;
	private String content;
	
	public String getGbookId() {
		return gbookId;
	}
	public void setGbookId(String gbookId) {
		this.gbookId = gbookId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getBbsDate() {
		return bbsDate;
	}
	public void setBbsDate(Date bbsDate) {
		this.bbsDate = bbsDate;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	
}