package com.javalec.mybbs.dao;

import java.util.List;

public interface IAttachDao {
	public List<String> attachList(String userId, String location);
	public void attachInsert(String fullName, String userId, String location);
	public void attachDelete(String fullName);
	public void locationDelete(String location);
}
