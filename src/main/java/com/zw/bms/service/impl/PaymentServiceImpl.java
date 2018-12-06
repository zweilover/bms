package com.zw.bms.service.impl;

import com.zw.bms.model.Payment;
import com.zw.bms.mapper.PaymentMapper;
import com.zw.bms.service.IPaymentService;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 计费账单表 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-04
 */
@Service
public class PaymentServiceImpl extends ServiceImpl<PaymentMapper, Payment> implements IPaymentService {
	
}
