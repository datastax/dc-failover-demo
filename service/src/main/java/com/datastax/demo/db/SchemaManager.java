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

    private static String createKeyspace(DemoServiceConfiguration config, String name) {
        return String.format(
                "CREATE KEYSPACE IF NOT EXISTS %s WITH REPLICATION = {'class':'NetworkTopologyStrategy','%s': 3,'%s': 3}",
                name,
                config.getDriverFactory().getLocalDataCenter(),
                config.getDriverFactory().getRemoteDataCenter()
        );
    }

    private static boolean isAlreadyCreated(CqlSession session, String ksName, String tableName) {
        return session.getMetadata().getKeyspace(ksName).isPresent() &&
            session.getMetadata().getKeyspace(ksName).get().getTable(tableName).isPresent() &&
            session.checkSchemaAgreement();
    }

    public static void createSchema(CqlSession session, DemoServiceConfiguration config) {
        // For the purpose of this demo, we check whether the tables already exist.
        // On a real world application, we should detach schema creation from the service deployment

        logger.info("Creating demo schema");

        session.execute(createKeyspace(config, "ks1"));
        session.execute("CREATE TABLE IF NOT EXISTS ks1.table1 (id int PRIMARY KEY)");
        session.execute(SimpleStatement.newInstance("INSERT INTO ks1.table1 (id) VALUES (?)", 1));

        logger.info("Creating shopping schema");

        session.execute(createKeyspace(config, "shopping"));
        session.execute("CREATE TABLE IF NOT EXISTS shopping.carts (" +
                "  username text," +
                "  item_id int," +
                "  date_added timestamp," +
                "  item_name text," +
                "  PRIMARY KEY (username, item_id, date_added))");
    }

    public static void waitSchema(CqlSession session) throws InterruptedException
    {
        int counter = 0;

        while (!isAlreadyCreated(session, "shopping", "carts") && !isAlreadyCreated(session, "ks1", "table1")) {
            if (counter++ >= 20) {
                throw new IllegalStateException("Schema was not found after waiting");
            }

            logger.info("Waiting for schema to be created...");
            Thread.sleep(5000);
        }

        logger.info("Schema is present");
    }
}
