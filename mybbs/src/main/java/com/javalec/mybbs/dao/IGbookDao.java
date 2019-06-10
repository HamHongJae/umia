package com.javalec.mybbs.dao;

import java.util.ArrayList;

import com.javalec.mybbs.dto.GbookDto;

public interface IGbookDao {
	public void gbookInsert(String userId, String content);
	public ArrayList<GbookDto> gbookList();
	public void gbookDelete(String gbookId);
}
