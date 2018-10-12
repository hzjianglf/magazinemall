package cn.core;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

/**
 * 二维码工具类
 */
public class QRCodeUtil {
	private static final int WIDTH = 100;// 默认二维码宽度/高度
	private static final String FORMAT = "png";// 默认二维码文件格式
	private static final Map<EncodeHintType, Object> HINTS = new HashMap<>();// 二维码参数

	static {
		HINTS.put(EncodeHintType.CHARACTER_SET, "utf-8");// 字符编码
		HINTS.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);// 容错等级 L、M、Q、H 其中 L 为最低, H 为最高
		HINTS.put(EncodeHintType.MARGIN, 2);// 二维码与图片边距
	}

	/**
	 * 返回一个 BufferedImage 对象
	 * 
	 * @param content
	 *            二维码内容
	 * @param width
	 *            宽/高
	 */
	public static BufferedImage toBufferedImage(String content, int width) throws WriterException, IOException {
		BitMatrix bitMatrix = new MultiFormatWriter().encode(content, BarcodeFormat.QR_CODE, width, width, HINTS);
		return MatrixToImageWriter.toBufferedImage(bitMatrix);
	}

	/**
	 * 返回一个 BufferedImage 对象，默认宽高100
	 * 
	 * @param content
	 *            二维码内容
	 * @return
	 * @throws WriterException
	 * @throws IOException
	 */
	public static BufferedImage toBufferedImage(String content) throws WriterException, IOException {
		return toBufferedImage(content, WIDTH);
	}

	/**
	 * 将二维码图片输出到一个流中
	 * 
	 * @param content
	 *            二维码内容
	 * @param stream
	 *            输出流
	 * @param width
	 *            宽/高
	 */
	public static void writeToStream(String content, OutputStream stream, int width)
			throws WriterException, IOException {
		BitMatrix bitMatrix = new MultiFormatWriter().encode(content, BarcodeFormat.QR_CODE, width, width, HINTS);
		MatrixToImageWriter.writeToStream(bitMatrix, FORMAT, stream);
	}

	/**
	 * 将二维码图片输出到一个流中，默认宽高100
	 * 
	 * @param content
	 *            二维码内容
	 * @param stream
	 *            输出流
	 * @throws WriterException
	 * @throws IOException
	 */
	public static void writeToStream(String content, OutputStream stream) throws WriterException, IOException {
		writeToStream(content, stream, WIDTH);
	}

	/**
	 * 生成二维码图片文件
	 * 
	 * @param content
	 *            二维码内容
	 * @param path
	 *            文件保存路径
	 * @param width
	 *            宽/高
	 */
	public static void createQRCode(String content, String path, int width) throws WriterException, IOException {
		BitMatrix bitMatrix = new MultiFormatWriter().encode(content, BarcodeFormat.QR_CODE, width, width, HINTS);
		// toPath() 方法由 jdk1.7 及以上提供
		MatrixToImageWriter.writeToPath(bitMatrix, FORMAT, new File(path).toPath());
	}

	/**
	 * 生成二维码图片文件，默认宽高100
	 * 
	 * @param content
	 *            二维码内容
	 * @param path
	 *            文件保存路径
	 * @throws WriterException
	 * @throws IOException
	 */
	public static void createQRCode(String content, String path) throws WriterException, IOException {
		createQRCode(content, path, WIDTH);
	}

}