package orsk.compli.controller.webScraper;

import io.jsonwebtoken.io.IOException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/scrape")
public class AdvancedWebScrapingController {

    private static final Logger logger = LoggerFactory.getLogger(AdvancedWebScrapingController.class);

    @GetMapping
    public ResponseEntity<?> scrapeWebsite(
            @RequestParam String url,
            @RequestParam(required = false) String elementSelector,
            @RequestParam(required = false, defaultValue = "false") boolean useProxy) {

        try {
            Document document;

            if (useProxy) {
                // Connect via a proxy
                document = Jsoup.connect(url)
                        .proxy("proxyHost", 8080) // Replace with actual proxy details
                        .get();
            } else {
                // Direct connection
                document = Jsoup.connect(url).get();
            }

            if (elementSelector != null && !elementSelector.isEmpty()) {
                Elements elements = document.select(elementSelector);
                return ResponseEntity.ok(elements.toString());
            }

            return ResponseEntity.ok(document.html());

        } catch (IOException e) {
            logger.error("Error scraping the website: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to scrape the website. Error: " + e.getMessage());
        } catch (java.io.IOException e) {
            throw new RuntimeException(e);
        }
    }
}