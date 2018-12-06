package com.zw.bms.service.impl;

import java.util.ArrayList;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.zw.bms.commons.exception.CommonException;
import com.zw.bms.commons.report.excel.ExcelUtil;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.FileOperateUtils;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.mapper.UploadFileMapper;
import com.zw.bms.model.UploadFile;
import com.zw.bms.service.IUploadFileService;

/**
 * <p>
 * 文件上传表 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
@Service
public class UploadFileServiceImpl extends ServiceImpl<UploadFileMapper, UploadFile> implements IUploadFileService {

	@Override
	public boolean saveAndUploadFileInfo(UploadFile uploadFile, MultipartFile file) {
		Map<String, String> returnMap = FileOperateUtils.fileUpload(file);
		if(returnMap.containsKey("success")){
			uploadFile.setFileName(returnMap.get("fileName"));
			uploadFile.setFilePath(returnMap.get("filePath"));
			uploadFile.setStatus("0");
			uploadFile.setCreateTime(DateUtil.getNowDateTimeString());
			uploadFile.setUpdateTime(DateUtil.getNowDateTimeString());
			uploadFile.setCreateUser(ShiroUtils.getLoginName());
			uploadFile.setUpdateUser(ShiroUtils.getLoginName());
			try{
				this.insert(uploadFile);
			}catch(Exception e){
				throw new CommonException("保存上传记录出错，请联系系统管理员！");
			}
		}else{
			throw new CommonException(returnMap.get("error"));
		}
		return true;
	}

	@Override
	public ArrayList<ArrayList<String>> readExcel4ImportFile(UploadFile uploadFile) {
		ArrayList<ArrayList<String>> list = null;
		try {
			list = ExcelUtil.excelReader(uploadFile.getFilePath());
		} catch (Exception e) {
			throw new CommonException("读取Excel出错，请检查导入文件是否有误！");
		}
		if(list == null || list.isEmpty()){
			throw new CommonException("未获取到Excel数据，请核对文件！");
		}
		return list;
	}
	
}
