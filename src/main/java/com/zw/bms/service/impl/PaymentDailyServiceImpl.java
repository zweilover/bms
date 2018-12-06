package com.zw.bms.service.impl;

import com.zw.bms.model.PaymentDaily;
import com.zw.bms.commons.exception.CommonException;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.mapper.PaymentDailyMapper;
import com.zw.bms.service.IPaymentDailyService;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-04-27
 */
@Service
public class PaymentDailyServiceImpl extends ServiceImpl<PaymentDailyMapper, PaymentDaily> implements IPaymentDailyService {

	@Autowired
	private PaymentDailyMapper paymentDailyMapper;
	
	/**
	 * 日账单结转数据查询
	 */
	@Override
	public List<HashMap<String, Object>> queryPaymentDailyData(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return paymentDailyMapper.queryPaymentDailyData(page, queryParam);
	}

	@Override
	@Transactional
	public void dealPaymentDaily(Map<String, Object> param) {
		EntityWrapper<PaymentDaily> ew = new EntityWrapper<PaymentDaily>();
		ew.and(" daily_date = {0} AND location = {1}",param.get("dailyDate"),param.get("location"));
		Integer i = paymentDailyMapper.selectCount(ew);
		if(i > 0){
			throw new CommonException("该结转日期已存在，请确认！");
		}
		
		// 1、查询条数，获取结转日期最大值和最小值
		List<HashMap<String,Object>> list = paymentDailyMapper.queryPaymentDetail4PaymentDaily(param);
		if(null == list || list.isEmpty() || (Long)list.get(0).get("count") == 0){
			throw new CommonException("未获取到结转数据！");
		}
		
		// 2、更新付款明细数据的结转日期
		try{
			paymentDailyMapper.updatePaymentDetailDailyDate(param);
		}catch(Exception e){
			throw new CommonException("更新付款明细的结转日期错误，请联系系统管理员！");
		}
		
		// 3、新增日结转数据
		HashMap<String,Object> map = list.get(0);
		String str_minBillTime = String.valueOf(map.get("minBillTime"));
		String str_maxBillTime = String.valueOf(map.get("maxBillTime"));
		PaymentDaily daily = new PaymentDaily();
		daily.setDailyDate(String.valueOf(param.get("dailyDate")));
		daily.setLocation(String.valueOf(param.get("location")));
		daily.setDateStart(str_minBillTime);
		daily.setDateEnd(str_maxBillTime);
		daily.setCreateTime(DateUtil.getNowDateTimeString());
		daily.setUpdateTime(DateUtil.getNowDateTimeString());
		daily.setCreateUser(ShiroUtils.getShiroUser().getLoginName());
		daily.setUpdateUser(ShiroUtils.getShiroUser().getLoginName());
		paymentDailyMapper.insert(daily);
	}

	@Override
	public List<HashMap<String, Object>> queryPaymentDailyHistory(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return paymentDailyMapper.queryPaymentDailyHistory(page, queryParam);
	}
	
}
