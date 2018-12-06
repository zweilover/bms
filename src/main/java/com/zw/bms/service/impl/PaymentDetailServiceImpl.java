package com.zw.bms.service.impl;

import com.zw.bms.model.PaymentDetail;
import com.zw.bms.mapper.PaymentDetailMapper;
import com.zw.bms.service.IPaymentDetailService;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 计费账单明细表 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-04
 */
@Service
public class PaymentDetailServiceImpl extends ServiceImpl<PaymentDetailMapper, PaymentDetail> implements IPaymentDetailService {
	
}
