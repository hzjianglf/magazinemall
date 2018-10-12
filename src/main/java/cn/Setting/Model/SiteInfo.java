package cn.Setting.Model;

public class SiteInfo {
	private String siteName;
	private String siteTitle;
	private String siteUrl;
	private String siteTel;
	private String metaKeywords;
	private String metaDescription;
	private String copyRight;
	private Integer defaultGradeId;
	private String imgUrl;
	private String address;
	private String pcSiteTitle;
	
	public String getPcSiteTitle() {
		return pcSiteTitle;
	}

	public void setPcSiteTitle(String pcSiteTitle) {
		this.pcSiteTitle = pcSiteTitle;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	private String email;
	private String icpNO;
	private Boolean siteStatus;
	private String closeTip;

	public String getSiteTel() {
		return siteTel;
	}

	public void setSiteTel(String siteTel) {
		this.siteTel = siteTel;
	}

	public String getMetaKeywords() {
		return metaKeywords;
	}

	@Override
	public String toString() {
		return "SiteInfo [siteName=" + siteName + ", siteTitle=" + siteTitle + ", siteUrl=" + siteUrl + ", siteTel="
				+ siteTel + ", metaKeywords=" + metaKeywords + ", metaDescription=" + metaDescription + ", copyRight="
				+ copyRight + ", defaultGradeId=" + defaultGradeId + ", imgUrl=" + imgUrl + ", address=" + address
				+ ", email=" + email + ", icpNO=" + icpNO + ", siteStatus=" + siteStatus + ", closeTip=" + closeTip
				+ "]";
	}

	public void setMetaKeywords(String metaKeywords) {
		this.metaKeywords = metaKeywords;
	}

	public String getMetaDescription() {
		return metaDescription;
	}

	public void setMetaDescription(String metaDescription) {
		this.metaDescription = metaDescription;
	}

	public String getSiteName() {
		return siteName;
	}

	public void setSiteName(String siteName) {
		this.siteName = siteName;
	}

	public String getSiteTitle() {
		return siteTitle;
	}

	public void setSiteTitle(String siteTitle) {
		this.siteTitle = siteTitle;
	}

	public String getSiteUrl() {
		return siteUrl;
	}

	public void setSiteUrl(String siteUrl) {
		this.siteUrl = siteUrl;
	}

	public String getCopyRight() {
		return copyRight;
	}

	public void setCopyRight(String copyRight) {
		this.copyRight = copyRight;
	}

	public Integer getDefaultGradeId() {
		return defaultGradeId;
	}

	public void setDefaultGradeId(Integer defaultGradeId) {
		this.defaultGradeId = defaultGradeId;
	}

	public String getImgUrl() {
		return imgUrl;
	}

	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getIcpNO() {
		return icpNO;
	}

	public void setIcpNO(String icpNO) {
		this.icpNO = icpNO;
	}

	public Boolean getSiteStatus() {
		return siteStatus;
	}

	public void setSiteStatus(Boolean siteStatus) {
		this.siteStatus = siteStatus;
	}

	public String getCloseTip() {
		return closeTip;
	}

	public void setCloseTip(String closeTip) {
		this.closeTip = closeTip;
	}

}
