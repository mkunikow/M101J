package course;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.QueryBuilder;

import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Random;

/**
 * Created by michal on 1/24/15.
 */
public class homework {
    public static void main(String[] args) throws UnknownHostException {
        MongoClient client = new MongoClient();
        DB db = client.getDB("students");
        DBCollection lines = db.getCollection("grades");


        DBObject query = QueryBuilder.start("type").is("homework").get();

        DBCursor cursor = lines.find(query)
                .sort(new BasicDBObject("student_id", 1).append("score", -1));

        LinkedList idsToRemove = new LinkedList<Object>();
        DBObject prevStudent = null;
        try {
            prevStudent = cursor.next();
            System.out.println(prevStudent);
            while (cursor.hasNext()) {
                DBObject currentStudent = cursor.next();
                if(((Integer)currentStudent.get("student_id")).intValue() != ((Integer)prevStudent.get("student_id")).intValue()){
                    idsToRemove.add(prevStudent.get("_id"));
                }
                prevStudent = currentStudent;
                System.out.println(currentStudent);
            }
        } finally {
            cursor.close();
        }

        //get last student
        idsToRemove.add(prevStudent.get("_id"));

        System.out.println("Ids to delete count " + idsToRemove.size());
        System.out.println("Ids to delete " + idsToRemove);

        DBObject delQuery = QueryBuilder.start("_id").in(idsToRemove).get();
        lines.remove(delQuery);
    }
}
