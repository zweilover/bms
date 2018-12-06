package com.zw.bms.service;

import com.zw.bms.model.PaymentDaily;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-04-27
 */
public interface IPaymentDailyService extends IService<PaymentDaily> {
	
	/**
	 * 日账单结转数据查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryPaymentDailyData(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 查询结转记录
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryPaymentDailyHistory(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 处理账单结转
	 * @param param
	 */
	public void dealPaymentDaily(Map<String,Object> param);
	
}
