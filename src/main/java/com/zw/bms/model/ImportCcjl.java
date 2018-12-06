package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 海关系统出仓记录
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
@TableName("bi_import_ccjl")
public class ImportCcjl extends Model<ImportCcjl> {

    private static final long serialVersionUID = 1L;

    /**
     * 主键id
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
	/**
	 * 创建日期
	 */
	@TableField("create_time")
	private String createTime;
	/**
	 * 创建人
	 */
	@TableField("create_user")
	private String createUser;
	/**
	 * 关联导入文件
	 */
	@TableField("file_id")
	private Long fileId;
    /**
     * 出仓id
     */
	private Long ccid;
	/**
	 * 状态
	 */
	private String zt;
    /**
     * 报关单号
     */
	private String bgdh;
    /**
     * 操作提示
     */
	private String czts;
    /**
     * 口岸地编码
     */
	private String kadbm;
    /**
     * 仓库编码
     */
	private String ckbm;
    /**
     * 仓库名称
     */
	private String ckmc;
    /**
     * 次卡备注信息
     */
	private String ckbzxx;
    /**
     * 通过时间
     */
	private String tgsj;
    /**
     * 出仓时间
     */
	private String ccsj;
    /**
     * 通道编号
     */
	private String tdbh;
    /**
     * 通道类型
     */
	private String tdlx;
    /**
     * 卡号
     */
	private String kh;
    /**
     * 运通卡类型
     */
	private String ytklx;
    /**
     * 车号
     */
	private String ch;
    /**
     * 出库单编号
     */
	private String ckdbh;
    /**
     * 保管公司
     */
	private String bggs;
    /**
     * 车辆类型
     */
	private String cllx;
    /**
     * 手输车号
     */
	private String ssch;
    /**
     * 抓拍车号
     */
	private String zpch;
    /**
     * 通关类型
     */
	private String tglx;
    /**
     * 车辆备案重量
     */
	private String clbazl;
    /**
     * 地磅采集重量
     */
	private String dbcjzl;
    /**
     * 货物净重
     */
	private String hwjz;
    /**
     * GPS编号
     */
	private String gpsbh;
    /**
     * 电子锁编号1
     */
	private String dzsbh1;
    /**
     * 电子锁编号2
     */
	private String dzsbh2;
    /**
     * 电子车牌1
     */
	private String dzcp1;
    /**
     * 电子车牌2
     */
	private String dzcp2;
    /**
     * 录入人
     */
	private String lrr;
    /**
     * 操作电脑名
     */
	private String czdnm;
    /**
     * 操作电脑ip
     */
	private String czdnip;
    /**
     * 交互标识
     */
	private String jhbz;
    /**
     * 备注
     */
	private String bz;


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getCcid() {
		return ccid;
	}

	public void setCcid(Long ccid) {
		this.ccid = ccid;
	}

	public String getZt() {
		return zt;
	}

	public void setZt(String zt) {
		this.zt = zt;
	}

	public String getBgdh() {
		return bgdh;
	}

	public void setBgdh(String bgdh) {
		this.bgdh = bgdh;
	}

	public String getCzts() {
		return czts;
	}

	public void setCzts(String czts) {
		this.czts = czts;
	}

	public String getKadbm() {
		return kadbm;
	}

	public void setKadbm(String kadbm) {
		this.kadbm = kadbm;
	}

	public String getCkbm() {
		return ckbm;
	}

	public void setCkbm(String ckbm) {
		this.ckbm = ckbm;
	}

	public String getCkmc() {
		return ckmc;
	}

	public void setCkmc(String ckmc) {
		this.ckmc = ckmc;
	}

	public String getCkbzxx() {
		return ckbzxx;
	}

	public void setCkbzxx(String ckbzxx) {
		this.ckbzxx = ckbzxx;
	}

	public String getTgsj() {
		return tgsj;
	}

	public void setTgsj(String tgsj) {
		this.tgsj = tgsj;
	}

	public String getCcsj() {
		return ccsj;
	}

	public void setCcsj(String ccsj) {
		this.ccsj = ccsj;
	}

	public String getTdbh() {
		return tdbh;
	}

	public void setTdbh(String tdbh) {
		this.tdbh = tdbh;
	}

	public String getTdlx() {
		return tdlx;
	}

	public void setTdlx(String tdlx) {
		this.tdlx = tdlx;
	}

	public String getKh() {
		return kh;
	}

	public void setKh(String kh) {
		this.kh = kh;
	}

	public String getYtklx() {
		return ytklx;
	}

	public void setYtklx(String ytklx) {
		this.ytklx = ytklx;
	}

	public String getCh() {
		return ch;
	}

	public void setCh(String ch) {
		this.ch = ch;
	}

	public String getCkdbh() {
		return ckdbh;
	}

	public void setCkdbh(String ckdbh) {
		this.ckdbh = ckdbh;
	}

	public String getBggs() {
		return bggs;
	}

	public void setBggs(String bggs) {
		this.bggs = bggs;
	}

	public String getCllx() {
		return cllx;
	}

	public void setCllx(String cllx) {
		this.cllx = cllx;
	}

	public String getSsch() {
		return ssch;
	}

	public void setSsch(String ssch) {
		this.ssch = ssch;
	}

	public String getZpch() {
		return zpch;
	}

	public void setZpch(String zpch) {
		this.zpch = zpch;
	}

	public String getTglx() {
		return tglx;
	}

	public void setTglx(String tglx) {
		this.tglx = tglx;
	}

	public String getClbazl() {
		return clbazl;
	}

	public void setClbazl(String clbazl) {
		this.clbazl = clbazl;
	}

	public String getDbcjzl() {
		return dbcjzl;
	}

	public void setDbcjzl(String dbcjzl) {
		this.dbcjzl = dbcjzl;
	}

	public String getHwjz() {
		return hwjz;
	}

	public void setHwjz(String hwjz) {
		this.hwjz = hwjz;
	}

	public String getGpsbh() {
		return gpsbh;
	}

	public void setGpsbh(String gpsbh) {
		this.gpsbh = gpsbh;
	}

	public String getDzsbh1() {
		return dzsbh1;
	}

	public void setDzsbh1(String dzsbh1) {
		this.dzsbh1 = dzsbh1;
	}

	public String getDzsbh2() {
		return dzsbh2;
	}

	public void setDzsbh2(String dzsbh2) {
		this.dzsbh2 = dzsbh2;
	}

	public String getDzcp1() {
		return dzcp1;
	}

	public void setDzcp1(String dzcp1) {
		this.dzcp1 = dzcp1;
	}

	public String getDzcp2() {
		return dzcp2;
	}

	public void setDzcp2(String dzcp2) {
		this.dzcp2 = dzcp2;
	}

	public String getLrr() {
		return lrr;
	}

	public void setLrr(String lrr) {
		this.lrr = lrr;
	}

	public String getCzdnm() {
		return czdnm;
	}

	public void setCzdnm(String czdnm) {
		this.czdnm = czdnm;
	}

	public String getCzdnip() {
		return czdnip;
	}

	public void setCzdnip(String czdnip) {
		this.czdnip = czdnip;
	}

	public String getJhbz() {
		return jhbz;
	}

	public void setJhbz(String jhbz) {
		this.jhbz = jhbz;
	}

	public String getBz() {
		return bz;
	}

	public void setBz(String bz) {
		this.bz = bz;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public Long getFileId() {
		return fileId;
	}

	public void setFileId(Long fileId) {
		this.fileId = fileId;
	}

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
