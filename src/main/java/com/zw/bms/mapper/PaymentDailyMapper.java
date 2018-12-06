package com.zw.bms.mapper;

import com.zw.bms.model.PaymentDaily;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
  *  Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2018-04-27
 */
public interface PaymentDailyMapper extends BaseMapper<PaymentDaily> {
	
	/**
	 * 日账单结转数据查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> queryPaymentDailyData(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/**
	 * 查询结转记录
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> queryPaymentDailyHistory(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/**
	 * 获取付款明细信息
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> queryPaymentDetail4PaymentDaily(@Param("param")Map<String,Object> queryParam);
	
	/**
	 * 更新付款明细的结转日期
	 * @param param
	 */
	void updatePaymentDetailDailyDate(@Param("param")Map<String,Object> param);

}