package startApp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.Month;    
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.TimeUnit;

import org.json.simple.JSONObject;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TreeItem;

import java.io.File;  

import java.io.FileWriter;  
import java.io.IOException;  
  
/**
 * @author snk14, zhehao
 *
 */
public class Simulator {
    
    // Temperature simulator 
    
    /** 
     * from http://aetinc.biz/newsletters/2010-insights/march-2010
     * 
     * Temperature                68-76oF (Winter)
     *                            73-79oF (Summer)
     * Relative Humidity          30-50% (Winter)
     *                            40-65% (Summer)
     *                            
     *                            My suggestions:
     *                            - Autumn 73
     *                            - Winter 79
     *                            
     *                            - Spring 68
     *                            - Summer 65
     */

    
    public static String sensorId;
    public static String timestamp;
    
    public static String location;
    public static String type;
    
    public static int value;

    public static String dbConn = "jdbc:mysql://localhost/smart_buildings?autoReconnect=true&useSSL=false&user=root&password=410305";
    
    public static ObservableList<String> SensorList = FXCollections.observableArrayList();
    //public final static  HashMap<String, date> sensordata = new HashMap<>();
    
public static void main(String[] args) {
    
    Timer t = new Timer();

    //Set the schedule function and rate
    t.scheduleAtFixedRate(
        new TimerTask() {
            @Override
            public void run() {
                simulating();  //Called each time when 1000 milliseconds (1 second) (the period parameter)
            }
        },
        0,     //Set how long before to start calling the TimerTask (in milliseconds)
        3000   //Set the amount of time between each execution (in milliseconds)
    );        
}


public static void simulating() {
    listsensors();
     
    System.out.println("List of sensors: " + SensorList);
    for (String e : SensorList) {
        DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
        Date date = new Date();
        timestamp= dateFormat.format(date);
      
        sensorId = e;
        value = select_season();
        location = get_location(e);
        sensorId = location + "_" + e;
        System.out.println("Sensor id: " + sensorId);  
      
        type = get_type(e);
        insertSensorQuery(value, timestamp, e);
        JSONObject obj = new JSONObject();  
        
        obj.put("sensor_id", sensorId);
        obj.put("sensor_type", get_type(e));
        
        obj.put("value", value);
        obj.put("timestamp", timestamp);
          
        try {  
            File file=new File("log.txt");  
            file.createNewFile();  
            FileWriter fileWriter = new FileWriter(file, true);  

            fileWriter.write(obj.toJSONString() + "\n");  
            fileWriter.flush();  
            fileWriter.close();  
      
        } catch (IOException ex) {  
            ex.printStackTrace();  
        }  
     
        System.out.print(obj);
    }
}
     

public static int select_season() {
    String season = null;

    ZoneId zoneId = ZoneId.of( "America/Montreal" );  // Or 'ZoneOffset.UTC'.
    ZonedDateTime now = ZonedDateTime.now( zoneId );
    Month month = now.getMonth();
    String season1 = getSeason(month.getValue());
    if ((season1 == "winter") || (season1=="autumn")) {
        Random generator = new Random();
        value = 73 + generator.nextInt(79 - 73 + 1);
    } else {
        Random generator = new Random();
        value = 68 + generator.nextInt(76 - 68 + 1);
    }
    return value; 
}
    
public static int getMonthInt(Date date) {

    SimpleDateFormat dateFormat = new SimpleDateFormat("MM");
    return Integer.parseInt(dateFormat.format(date));
}
     
static String getSeason(int month) {
    switch(month) {
        case 11:
        case 12:
        case 1:
        case 2:
            return "winter";
        case 3:
        case 4:
            return "spring";
        case 5:
        case 6:
        case 7:
        case 8:
            return "summer";
        default:
            return "autumn";
      }
}
     
     public static void  listsensors(){
            Connection conn = null;
            Statement stmt = null;
            try{
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(dbConn);
                stmt = conn.createStatement();

                //STEP 4: Execute a query
                //System.out.println("Creating statement...");
                stmt = conn.createStatement();
                String sql;
                sql = "SELECT sensor_id FROM sensor";
                ResultSet rs = stmt.executeQuery(sql);

                //STEP 5: Extract data from result set
                SensorList.clear();
                while(rs.next()){
                    //Retrieve by column name
                    String sensor_id  = rs.getString("sensor_id");
                    

                    //Display values
                    //System.out.print(" sensor_id : " + sensor_id);
                    
                    // adding to list of sensors

                    
                    SensorList.add(sensor_id);
                }
                //STEP 6: Clean-up environment
                rs.close();
                stmt.close();
                conn.close();
            }catch(SQLException se){
                //Handle errors for JDBC
                se.printStackTrace();
            }catch(Exception e){
                //Handle errors for Class.forName
                e.printStackTrace();
            }finally{
                //finally block used to close resources
                try{
                    if(stmt!=null)
                        stmt.close();
                }catch(SQLException se2){
                }// nothing we can do
                try{
                    if(conn!=null)
                        conn.close();
                }catch(SQLException se){
                    se.printStackTrace();
                }//end finally try
            }//end try
            //System.out.println("Goodbye!");
            
        }//end FirstExample
     
     
     public static void insertSensorQuery(int value, String timestamp, String sensor_id)  {
         
         try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
         
            Connection conn = null;
            Statement stmt = null;
            try{
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(dbConn);

                stmt = conn.createStatement();
                String sql = "INSERT INTO data "+"VALUES ("+value+",'"+timestamp+"','"+sensor_id+"')";
                //System.out.println(sql);
                stmt.executeUpdate(sql);
            }catch(SQLException se){
                //Handle errors for JDBC
                se.printStackTrace();
            }catch(Exception e){
                //Handle errors for Class.forName
                e.printStackTrace();
            }finally{
                //finally block used to close resources
                try{
                    if(stmt!=null)
                        conn.close();
                }catch(SQLException se){
                }// do nothing
                try{
                    if(conn!=null)
                        conn.close();
                }catch(SQLException se){
                    se.printStackTrace();
                }//end finally try
            }//end try
        }    
     
     public static String get_type(String bname)
        {
            //
         String type = null;
            //ObservableList<String> floorsdb1 = FXCollections.observableArrayList();
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbConn);
                Statement stmt = conn.createStatement();

                String sql;

                sql = "SELECT sensor_type FROM sensor WHERE sensor_id ='"+bname+"'";

                ResultSet rs = stmt.executeQuery(sql);

                while(rs.next()){
                    type =rs.getString("sensor_type");
                }

                //System.out.println(floorsdb1);

                rs.close();
                stmt.close();
                conn.close();   
                //System.out.println("test");

            }catch(SQLException se){
                se.printStackTrace();
            }catch(Exception e){
                e.printStackTrace();
            }finally{
                //finally block used to close resources

            }//end try
            return type;

        }
     
     
    public static String get_location(String bname)
    {
        //
     String location = null;
        //ObservableList<String> floorsdb1 = FXCollections.observableArrayList();
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbConn);
            Statement stmt = conn.createStatement();

            String sql;

            sql = "SELECT sensor_location FROM sensor WHERE sensor_id ='"+bname+"'";

            ResultSet rs = stmt.executeQuery(sql);

            while(rs.next()){
                location =rs.getString("sensor_location");
            }

            //System.out.println(floorsdb1);

            rs.close();
            stmt.close();
            conn.close();   
            //System.out.println("test");

        }catch(SQLException se){
            se.printStackTrace();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            //finally block used to close resources

        }//end try
        return location;
    }
}
