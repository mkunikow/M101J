package course;

import com.mongodb.*;

import java.net.UnknownHostException;
import java.util.*;

/**
 * Created by michal on 1/24/15.
 */
public class homework {
    public static void main(String[] args) throws UnknownHostException {
        MongoClient client = new MongoClient();
        DB db = client.getDB("school");
        DBCollection students = db.getCollection("students");

        DBCursor cursor = students.find()
                .sort(new BasicDBObject("_id", 1));

        try {
            while (cursor.hasNext()) {
                DBObject student = cursor.next();
                BasicDBList scores = (BasicDBList) student.get("scores");
                Optional<DBObject> scoreOpt = findTheLowestHomeworkScore(scores);
                DBObject score = scoreOpt.orElseGet(null);
                System.out.println(student.get("scores"));
                if (scoreOpt.isPresent()) {
                    System.out.println("delete score: " + score);
                    scores.remove(score);
                    updateScores(students, student, scores);
                }
                System.out.println("\n");
            }
        } finally {
            cursor.close();
        }
    }

    private static Optional<DBObject> findTheLowestHomeworkScore(BasicDBList scores) {
        DBObject[] scoresArr =  scores.toArray(new DBObject[0]);
        List<DBObject> scoresList = Arrays.asList(scoresArr);
        return scoresList
                .stream()
                .filter(s -> s.get("type").equals("homework"))
                .sorted((s1,s2) -> ((Double)s1.get("score")).compareTo((Double)s2.get("score")))
                .findFirst();
    }

    private static void updateScores(DBCollection students, DBObject student, BasicDBList scores) {
        BasicDBObject findToUpdateQuery = new BasicDBObject("_id",
                student.get("_id"));

        BasicDBObject updateQuery = new BasicDBObject("$set",
                new BasicDBObject("scores", scores));
        WriteResult result = students.update(findToUpdateQuery, updateQuery);

        System.out.println(result);

    }
}
