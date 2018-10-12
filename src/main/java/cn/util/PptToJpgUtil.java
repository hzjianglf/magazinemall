package cn.util;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.apache.poi.hslf.usermodel.HSLFShape;
import org.apache.poi.hslf.usermodel.HSLFSlideShow;
import org.apache.poi.hslf.usermodel.HSLFSlideShowImpl;
import org.apache.poi.hslf.usermodel.HSLFTextParagraph;
import org.apache.poi.hslf.usermodel.HSLFTextRun;
import org.apache.poi.hslf.usermodel.HSLFTextShape;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFShape;
import org.apache.poi.xslf.usermodel.XSLFTextParagraph;
import org.apache.poi.xslf.usermodel.XSLFTextRun;
import org.apache.poi.xslf.usermodel.XSLFTextShape;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.api.service.PathService;
@Service
public class PptToJpgUtil {
	@Autowired
	Setting setting;
	/**
	 * ppt2007文档的转换 后缀为.pptx
	 * @param pptFile PPT文件路径
	 * @param imgFile 图片将要保存的路径目录（不是文件）
	 * @return
	 */
	public  List<String> toImage2007(String pptFile,String imgFile) throws Exception{
		
		List<String> list = new ArrayList<String>();
		
		FileInputStream is = new FileInputStream(pptFile);
		XMLSlideShow ppt = new XMLSlideShow(is);
		is.close();
		
		Dimension pgsize = ppt.getPageSize();
		//System.out.println(pgsize.width+"--"+pgsize.height);
		
		for (int i = 0; i < ppt.getSlides().size(); i++) {
			try {
				//防止中文乱码
				for(XSLFShape shape : ppt.getSlides().get(i).getShapes()){
					if(shape instanceof XSLFTextShape) {
						XSLFTextShape tsh = (XSLFTextShape)shape;
						for(XSLFTextParagraph p : tsh){
							for(XSLFTextRun r : p){
								r.setFontFamily("宋体");
							}
						}
					}
				}
				BufferedImage img = new BufferedImage(pgsize.width, pgsize.height, BufferedImage.TYPE_INT_RGB);
				Graphics2D graphics = img.createGraphics();
				// clear the drawing area
				graphics.setPaint(Color.white);
				graphics.fill(new Rectangle2D.Float(0, 0, pgsize.width, pgsize.height));
				
				// render
				ppt.getSlides().get(i).draw(graphics);
				String path = UUID.randomUUID().toString();
				imgFile = imgFile.replaceAll("\\\\", "/");
				// save the output
				SimpleDateFormat sdfFolderName = new SimpleDateFormat("yyyyMMdd");
				String newFolderName = sdfFolderName.format(new Date());
				String filename = imgFile + path + ".jpg";
				list.add(setting.getSetting(SiteInfo.class).getSiteUrl()+"/upload/ppt/"+newFolderName+"/"+path+ ".jpg");
				FileOutputStream out = new FileOutputStream(filename);
				javax.imageio.ImageIO.write(img, "png", out);
				out.close();
			} catch (Exception e) {
				System.out.println("第"+i+"张ppt转换出错"+e.getMessage());
			}
		}
		System.out.println("PPT转换成图片 成功！");
		return list;
	}
	/**
	 * ppt2003 文档的转换 后缀名为.ppt
	 * @param pptFile ppt文件路径
	 * @param imgFile 图片将要保存的目录（不是文件）
	 * @return
	 */
	public  List<String> toImage2003( String pptFile,String imgFile ){
		
		List<String> list = new ArrayList<String>();
		File newFile = new File(imgFile);
		if(!newFile.exists()){  
			newFile.mkdirs();  
		} 
		try {
			HSLFSlideShow ppt = new HSLFSlideShow(new HSLFSlideShowImpl(pptFile));
			
			Dimension pgsize = ppt.getPageSize();
			for (int i = 0; i < ppt.getSlides().size(); i++) {
				//防止中文乱码
				for(HSLFShape shape : ppt.getSlides().get(i).getShapes()){
					if(shape instanceof HSLFTextShape) {
						HSLFTextShape tsh = (HSLFTextShape)shape;
						for(HSLFTextParagraph p : tsh){
							for(HSLFTextRun r : p){
								r.setFontFamily("宋体");
							}
						}
					}
				}
				BufferedImage img = new BufferedImage(pgsize.width, pgsize.height, BufferedImage.TYPE_INT_RGB);
				Graphics2D graphics = img.createGraphics();
				// clear the drawing area
				graphics.setPaint(Color.white);
				graphics.fill(new Rectangle2D.Float(0, 0, pgsize.width, pgsize.height));
				
				// render
				ppt.getSlides().get(i).draw(graphics);
				String path = UUID.randomUUID().toString();
				imgFile = imgFile.replaceAll("\\\\", "/");
				// save the output
				SimpleDateFormat sdfFolderName = new SimpleDateFormat("yyyyMMdd");
				String newFolderName = sdfFolderName.format(new Date());
				String filename = imgFile + path + ".jpg";
				list.add(setting.getSetting(SiteInfo.class).getSiteUrl()+"/upload/ppt/"+newFolderName+"/"+path+ ".jpg");
				FileOutputStream out = new FileOutputStream(filename);
				javax.imageio.ImageIO.write(img, "png", out);
				out.close();
//				resizeImage(filename, filename, width, height);
				
			}
			System.out.println("PPT转换成图片 成功！");
		} catch (Exception e) {
			System.out.println("PPT转换 失败"+e.getMessage());
		}
		return list;
	}

}
