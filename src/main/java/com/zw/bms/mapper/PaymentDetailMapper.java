package com.zw.bms.mapper;

import com.zw.bms.model.PaymentDetail;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.baomidou.mybatisplus.mapper.BaseMapper;

/**
 * <p>
  * 计费账单明细表 Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-04
 */
public interface PaymentDetailMapper extends BaseMapper<PaymentDetail> {
	/**
	 * 根据车辆id获取付款明细
	 * @param id
	 * @return
	 */
	List<PaymentDetail> getPaymentDetailByCarId(@Param("id")Long id);
}