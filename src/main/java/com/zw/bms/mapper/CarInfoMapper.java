package com.zw.bms.mapper;

import com.zw.bms.model.CarInfo;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
  *  Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-28
 */
public interface CarInfoMapper extends BaseMapper<CarInfo> {
	List<CarInfo> selectCarInfoList(Page<CarInfo> page,@Param("carInfo")CarInfo carInfo);
	
	List<CarInfo> selectCarList4CarOut(Page<CarInfo> page,@Param("carInfo")CarInfo carInfo);
	
	CarInfo getCarInfoDetail(@Param("id")Long id);

}