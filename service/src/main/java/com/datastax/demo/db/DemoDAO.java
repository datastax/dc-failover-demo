package com.datastax.demo.db;

import com.datastax.demo.api.DemoEntity;
import com.datastax.oss.driver.api.core.ConsistencyLevel;
import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.DefaultConsistencyLevel;
import com.datastax.oss.driver.api.core.cql.BoundStatement;
import com.datastax.oss.driver.api.core.cql.PreparedStatement;
import com.datastax.oss.driver.api.core.cql.Row;

public class DemoDAO
{
    private final CqlSession session;
    private final PreparedStatement psSelect;
    private final PreparedStatement psInsert;

    private static final ConsistencyLevel READ_CONSISTENCY_LEVEL = DefaultConsistencyLevel.LOCAL_ONE;
    private static final ConsistencyLevel WRITE_CONSISTENCY_LEVEL = DefaultConsistencyLevel.LOCAL_ONE;

    public DemoDAO(CqlSession session)
    {
        this.session = session;

        psSelect = session.prepare("SELECT * FROM ks1.table1 WHERE id = ?");
        psInsert = session.prepare("INSERT INTO ks1.table1 (id) VALUES (?)");
    }

    public DemoEntity get(int id)
    {
        final BoundStatement statement = psSelect.bind(id).setConsistencyLevel(READ_CONSISTENCY_LEVEL);

        final Row row = session.execute(statement).one();
        if (row == null) {
            return null;
        }

        return new DemoEntity(row.getInt("id"), "got from db");
    }

    public DemoEntity create(DemoEntity entity)
    {
        final BoundStatement statement = psInsert.bind(entity.getId()).setConsistencyLevel(WRITE_CONSISTENCY_LEVEL);
        session.execute(statement);
        return entity;
    }
}
