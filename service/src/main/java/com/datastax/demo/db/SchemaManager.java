package com.datastax.demo.db;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.datastax.demo.DemoServiceApplication;
import com.datastax.demo.DemoServiceConfiguration;
import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.cql.SimpleStatement;

public class SchemaManager
{
    private static final Logger logger = LoggerFactory.getLogger(DemoServiceApplication.class);

    public static void createSchema(CqlSession session, DemoServiceConfiguration config) {
        // For the purpose of this demo, we check whether the tables already exist.
        // On a real world application, we should detach schema creation from the service deployment

        if (session.getMetadata().getKeyspace("ks1").isPresent() &&
            session.getMetadata().getKeyspace("ks1").get().getTable("tbl1").isPresent()) {
            return;
        }

        logger.info("Creating schema");

        final String createKeyspaceQuery = String.format(
            "CREATE KEYSPACE IF NOT EXISTS ks1 WITH REPLICATION = {'class':'NetworkTopologyStrategy','%s': 3,'%s': 3}",
            config.getDriverFactory().getLocalDataCenter(),
            config.getDriverFactory().getRemoteDataCenter()
        );

        session.execute(createKeyspaceQuery);
        session.execute("CREATE TABLE IF NOT EXISTS ks1.table1 (id int PRIMARY KEY)");
        session.execute(SimpleStatement.newInstance("INSERT INTO ks1.table1 (id) VALUES (?)", 1));
    }
}
