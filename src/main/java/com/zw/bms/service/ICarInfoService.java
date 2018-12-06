package com.zw.bms.service;

import com.zw.bms.model.CarInfo;
import com.zw.bms.model.PaymentDetail;
import java.util.List;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-28
 */
public interface ICarInfoService extends IService<CarInfo> {
	/**
	 * 获取车辆信息列表
	 * @param page
	 * @param carInfo
	 * @return
	 */
	List<CarInfo> selectCarInfoList(Page<CarInfo> page,CarInfo carInfo);
	
	/**
	 * 获取车辆列表，适用于出库收费选择关联入库车辆
	 * @param page
	 * @param carInfo
	 * @return
	 */
	List<CarInfo> selectCarList4CarOut(Page<CarInfo> page,CarInfo carInfo);
	
	/**
	 * 根据id获取车辆详细信息
	 * @param id
	 * @return
	 */
	CarInfo getCarInfoDetail(Long id);
	
	/**
	 * 根据车辆id获取付款明细
	 * @param id
	 * @return
	 */
	List<PaymentDetail> getPaymentDetailByCarId(Long id);
	
	/**
	 * 车辆登记入库唯一性校验
	 * @return
	 */
	void checkUnique4CardInfo(CarInfo carInfo);
	
	/**
	 * 生成计费明细
	 * @param carInfo
	 * @return
	 */
	List<PaymentDetail> genPaymentDetail(CarInfo carInfo);
	
	/**
	 * 处理付款
	 * @param carInfo
	 */
	void dealPayment(CarInfo carInfo);
	
}
