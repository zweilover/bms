package com.zw.bms.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
  *  Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-09
 */
public interface ReportQueryMapper {

	/**
	 * 车辆报表查询
	 * @param queryParam  查询参数
	 * @return
	 */
	List<HashMap<String,Object>> queryCarInfoReport(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/**
	 * 客户账户信息汇总查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> queryCustAccountReport(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/**
	 * 客户账户信息明细
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> queryCustAccountDetailReport(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/**
	 * 森桥日报表查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> queryDailyReport4SqList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/**
	 * 福地日报表查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> queryDailyReport4FdList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/** 森桥月报表查询
	* @param page
	* @param queryParam
	* @return
	*/
	List<HashMap<String,Object>> queryMonthlyReport4SqList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/** 森桥年报表查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> queryYearReport4SqList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/** 客户回款进度查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> queryCustomerReturnMoneyList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/** 货物出入库报表查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> queryDailyReport4StoreDetailList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/** 货物出入库报表查询(以客户和库房维度)
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> queryDailyReport4CustomerStoreList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
}