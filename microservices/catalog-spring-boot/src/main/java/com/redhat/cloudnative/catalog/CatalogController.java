package com.redhat.cloudnative.catalog;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Spliterator;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.redhat.cloudnative.catalog.breakfix.service.BreakFixService;

@Controller
@RequestMapping(value = "/api/catalog")
public class CatalogController {

	@Autowired
    private ProductRepository repository;
	
	@Autowired
	private BreakFixService breakFixService;

    @ResponseBody
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<Product>> getAll() {
        Spliterator<Product> products = repository.findAll().spliterator();
        List<Product> result = StreamSupport.stream(products, false).collect(Collectors.toList());
        
        HttpStatus httpStatus = HttpStatus.OK;
        
        try {
        	breakFixService.process();
        } catch (RuntimeException re) {
        	result = new ArrayList<Product>(); // No data
        	if ((new Random()).nextInt(10) % 2 == 0) {
        		httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
        	} else {
        		httpStatus = HttpStatus.NOT_FOUND;
        	}
        }
                
        return new ResponseEntity<>(result, httpStatus);
    }
    
}