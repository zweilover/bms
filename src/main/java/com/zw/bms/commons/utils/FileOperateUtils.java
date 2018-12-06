package com.zw.bms.commons.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

/**
 * 附件处理工具类
 * @author zw
 */
public class FileOperateUtils {
	
	private static Logger logger = LogManager.getLogger(FileOperateUtils.class);

	public static Map<String, String> fileUpload(MultipartFile sourceFile){
		logger.info("开始上传文件......");
		Map<String, String> result = new HashMap<String, String>();
		String uploadFileName = sourceFile.getOriginalFilename();
		String uploadDir = PropertyUtils.getProperty("excelUploadPath");//上传文件路径
        String fileEx = uploadFileName.substring(uploadFileName.lastIndexOf("."), uploadFileName.length());//文件后缀名
        String newFileName = new Date().getTime() + fileEx; //防止文件名称重复，重命名
        String newFilePath = uploadDir + newFileName;//新文件路径
		
        File file = new File(uploadDir);	
        if(!file.exists()){
        	file.mkdirs();
        }
        try {
        	FileOutputStream outputStream = new FileOutputStream(newFilePath);
        	FileCopyUtils.copy(sourceFile.getInputStream(), outputStream);//文件上传
        } catch (IOException e) {
        	logger.error("出现IOException,文件上传失败!",e.getMessage());
        	result.put("error", "文件上传失败，请联系系统管理员！");
        	return result;
        }
        
        logger.info("文件上传成功!");
        result.put("success", "文件上传成功！");
        result.put("fileName", uploadFileName);
        result.put("filePath", newFilePath);
		return result;
	}
}
