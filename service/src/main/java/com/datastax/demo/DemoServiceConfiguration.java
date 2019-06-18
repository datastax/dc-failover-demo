package com.datastax.demo;

import io.dropwizard.Configuration;
import com.fasterxml.jackson.annotation.JsonProperty;

import javax.validation.Valid;
import javax.validation.constraints.*;

import com.datastax.demo.core.DriverFactory;

public class DemoServiceConfiguration extends Configuration {
    @Valid
    @NotNull
    private DriverFactory driverFactory = new DriverFactory();

    @JsonProperty("driverFactory")
    public DriverFactory getDriverFactory() {
        return driverFactory;
    }

    @JsonProperty("driverFactory")
    public void setDriverFactory(DriverFactory factory) {
        this.driverFactory = factory;
    }
}
