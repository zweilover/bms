package com.zw.bms.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-09
 */
public interface IReportQueryService{
	/**
	 * 车辆信息报表查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryCarInfoReport(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 客户账户信息汇总查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryCustAccountReport(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 客户账户信息明细
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryCustAccountDetailReport(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 森桥日报表查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryDailyReport4SqList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 福地日报表查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryDailyReport4FdList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 森桥月报表查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryMonthlyReport4SqList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 森桥年报表查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryYearReport4SqList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 客户回款进度查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryCustomerReturnMoneyList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 货物出入库报表查询
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryDailyReport4StoreDetailList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 货物出入库报表查询(以客户和库房维度)
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> queryDailyReport4CustomerStoreList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
}
