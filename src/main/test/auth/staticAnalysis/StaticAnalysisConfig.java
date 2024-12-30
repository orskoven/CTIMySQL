// src/main/java/orsk/authmodule/tests/StaticAnalysisConfig.java
package auth.staticAnalysis;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

@Configuration
public class StaticAnalysisConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info().title("API Documentation")
                        .version("1.0")
                        .description("Static Analysis Tools Integration"));
    }

    @Bean
    public Docket api() {
        return new Docket(DocumentationType.OAS_30)
          .select()
          .apis(RequestHandlerSelectors.basePackage("orsk.authmodule.controller"))
          .paths(PathSelectors.any())
          .build();
    }
}
