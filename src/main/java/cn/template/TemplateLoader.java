package cn.template;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.dao.DuplicateKeyException;

import cn.template.Template.TemplateType;
import cn.util.ClassUtil;
import cn.util.SpringContextUtils;

public class TemplateLoader {
	private static Map<String, Class<?>> map;
	private static Map<String, TemplateType> typeMap;

	public static Set<String> getNames() {
		EnsureMap();
		return map.keySet();
	}

	public static Set<String> getNames(TemplateType type) {
		EnsureMap();
		Set<String> result = new HashSet<String>();
		for (Map.Entry<String, TemplateType> entry : typeMap.entrySet()) {
			if (entry.getValue() == type) {
				result.add(entry.getKey());
			}
		}

		return result;
	}

	public static ITemplate get(String view) {
		EnsureMap();
		Class<?> class1 = map.get(view);
		if (class1 == null) {
			throw new NullPointerException("template type is not founded");
		}
		Object object = SpringContextUtils.getContext().getBean(class1);
		if (object == null) {
			return null;
		}
		return (ITemplate) object;
	}

	private static void EnsureMap() {
		if (map == null) {
			typeMap = new HashMap<String, TemplateType>();
			map = new HashMap<String, Class<?>>();
			List<Class<?>> classes = ClassUtil.getAllClassByInterface(ITemplate.class);
			for (Class<?> clazz : classes) {

				Template template = clazz.getAnnotation(Template.class);
				if (map.containsKey(template.name())) {
					throw new DuplicateKeyException("template name " + template.name() + " is duplicated");
				}

				map.put(template.name(), clazz);
				typeMap.put(template.name(), template.type());

			}

		}
	}
}
