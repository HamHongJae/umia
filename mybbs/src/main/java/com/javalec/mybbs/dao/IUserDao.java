package com.javalec.mybbs.dao;
import javax.servlet.http.HttpSession;

import com.javalec.mybbs.dto.UserDto;


public interface IUserDao {
	public void logout(HttpSession session);
	public String loginCheckGetName(String userId, String userPassword);
	public void sign_up(String parameter, String parameter2, String parameter3, String parameter4, String parameter5);
	public String idCheck(String userId);
	public UserDto viewUser(String userId);
}
