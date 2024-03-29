package cn;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.async.DeferredResult;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
public class Swagger2   {
	
	@Bean  
    public Docket restApi() {  
        return new Docket(DocumentationType.SWAGGER_2)  
                .apiInfo(apiInfo())  
                .groupName("APP请求接口")  
                .genericModelSubstitutes(DeferredResult.class)  
                .useDefaultResponseMessages(false)  
                .forCodeGeneration(true)  
                .select()  
                .apis(RequestHandlerSelectors.basePackage("cn.api.controller"))
                .paths(PathSelectors.any())
                .build();  
    }  
    
  
    private ApiInfo apiInfo() {  
        return new ApiInfoBuilder()  
                .title("销售与市场Api列表")  
                .description("用于APP接口调试及查询")  
                .contact("鹏翔科技")  
                .version("1.0")  
                .license("鹏翔科技")  
                .licenseUrl("http://www.pxkeji.com")  
                .build();  
    }  
}
