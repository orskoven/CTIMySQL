// File: src/main/java/orsk/compli/dtos/SearchOptionsResponse.java

package orsk.compli.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class SearchOptionsResponse {
    private List<String> products;
    private List<String> countries;
    private List<String> threats;
    // Add more fields as needed
}