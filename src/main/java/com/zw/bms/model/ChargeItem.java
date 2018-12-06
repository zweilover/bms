package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 计费子项
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-18
 */
@TableName("bi_charge_item")
public class ChargeItem extends Model<ChargeItem> {

    private static final long serialVersionUID = 1L;

    /**
     * ID
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 子项名称
     */
	private String name;
    /**
     * 费用类型，关联字典表中code
     */
	private String type;
	/**
	 * 费用所属区域,字典code
	 */
	private String location;
	/**
	 * 排序
	 */
	private Integer seq;
    /**
     * 上限值
     */
	@TableField("min_value")
	private Long minValue;
	/**
	 * 上限值
	 */
	@TableField("max_value")
	private Long maxValue;
    /**
     * 计费参数，取自字典项
     */
	@TableField("item_param")
	private Long itemParam;
	
    /**
     * 价格
     */
	private Double cost;
    /**
     * js脚本参数,取自字典项
     */
	@TableField("script_param")
	private Long scriptParam;
	
    /**
     * js脚本，用于费用计算
     */
	@TableField("script_str")
	private String scriptStr;
	
    /**
     * 状态,0:正常;1:停用;2:删除
     */
	private String status;
	
    /**
     * 收费子项描述
     */
	private String remark;
	
	/**
	 * 创建人
	 */
	@TableField("create_user")
	private String createUser;
	
	/**
	 * 最后更新人
	 */
	@TableField("update_user")
	private String updateUser;
	
    /**
     * 创建时间
     */
	@TableField("create_time")
	private String createTime;
	
	/**
	 * 最后更新时间
	 */
	@TableField("update_time")
	private String updateTime;
	
	
	/*******  不在数据库中的字段    **********/
	/**
	 * 创建人名称
	 */
	@TableField(exist = false)
	private String createUserName;
	
	/**
	 * 所属区域名称
	 */
	@TableField(exist = false)
	private String locationName;
	
	/**
	 * 最后更新人名称
	 */
	@TableField(exist = false)
	private String updateUserName;
	
	/**
	 * 类型名称
	 */
	@TableField(exist = false)
	private String typeName;
	
	/**
	 * 计费参数名称
	 */
	@TableField(exist = false)
	private String itemParamName;
	
	/**
	 * 脚本参数名称
	 */
	@TableField(exist = false)
	private String scriptParamName;
	
	/**
	 * 计费参数名称
	 */
	@TableField(exist = false)
	private String itemParamCode;
	
	/**
	 * 脚本参数名称
	 */
	@TableField(exist = false)
	private String scriptParamCode;
	
	/*******  不在数据库中的字段    **********/


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public Integer getSeq() {
		return seq;
	}

	public void setSeq(Integer seq) {
		this.seq = seq;
	}

	public Long getMinValue() {
		return minValue;
	}

	public void setMinValue(Long minValue) {
		this.minValue = minValue;
	}
	
	public Long getMaxValue() {
		return maxValue;
	}
	
	public void setMaxValue(Long maxValue) {
		this.maxValue = maxValue;
	}

	public Long getItemParam() {
		return itemParam;
	}

	public void setItemParam(Long itemParam) {
		this.itemParam = itemParam;
	}

	public Double getCost() {
		return cost;
	}

	public void setCost(Double cost) {
		this.cost = cost;
	}

	public Long getScriptParam() {
		return scriptParam;
	}

	public void setScriptParam(Long scriptParam) {
		this.scriptParam = scriptParam;
	}

	public String getScriptStr() {
		return scriptStr;
	}

	public void setScriptStr(String scriptStr) {
		this.scriptStr = scriptStr;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	
	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public String getCreateUserName() {
		return createUserName;
	}

	public void setCreateUserName(String createUserName) {
		this.createUserName = createUserName;
	}

	public String getUpdateUserName() {
		return updateUserName;
	}

	public void setUpdateUserName(String updateUserName) {
		this.updateUserName = updateUserName;
	}

	public String getItemParamName() {
		return itemParamName;
	}

	public void setItemParamName(String itemParamName) {
		this.itemParamName = itemParamName;
	}

	public String getScriptParamName() {
		return scriptParamName;
	}

	public void setScriptParamName(String scriptParamName) {
		this.scriptParamName = scriptParamName;
	}
	
	public String getItemParamCode() {
		return itemParamCode;
	}

	public void setItemParamCode(String itemParamCode) {
		this.itemParamCode = itemParamCode;
	}

	public String getTypeName() {
		return typeName;
	}

	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}

	public String getScriptParamCode() {
		return scriptParamCode;
	}

	public void setScriptParamCode(String scriptParamCode) {
		this.scriptParamCode = scriptParamCode;
	}

	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
