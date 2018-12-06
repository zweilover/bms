package com.zw.bms.commons.utils;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


/**
 * 文件获取工具类
 * @author zw
 *
 */
public class PropertyUtils {

	private static Logger logger = LogManager.getLogger(PropertyUtils.class);

	// 配置文件
	private static Properties props;
	
//	static {
//		loadProps();
//	}
	
	private static void loadProps(){
		logger.info("开始加载properties文件内容.......");
        props = new Properties();
        InputStream in = null;
        try {
            in = PropertyUtils.class.getResourceAsStream("/config/application.properties");
            props.load(in);
        } catch (FileNotFoundException e) {
        	logger.error("jdbc.properties文件未找到");
        } catch (IOException e) {
            logger.error("出现IOException");
        } finally {
            try {
                if(null != in) {
                    in.close();
                }
            } catch (IOException e) {
                logger.error("jdbc.properties文件流关闭出现异常");
            }
        }
        logger.info("加载properties文件内容完成...........");
        logger.info("properties文件内容：" + props);
	}
	
	public static String getProperty(String key){
        if(null == props) {
            loadProps();
        }
        return props.getProperty(key);
    }
	
	public static String getProperty(String key, String defaultValue) {
        if(null == props) {
            loadProps();
        }
        return props.getProperty(key, defaultValue);
    }
	
}
