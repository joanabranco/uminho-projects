import java.sql.Timestamp;

/**
 * Classe com o objetivo de guardar a cache representativa de cada um dos servidores
 * Autor: Joana
 * Data: 20/11/2022
 */

public class ResourceRecord {
    //estrutura de cada uma das linhas da cache:
    private String name;
    private String type;
    private String value;
    private int ttl;
    private int order; //priority
    private String origin; //FILE, SP ou OTHERS
    private int index; //índice da linha na cache
    private String status; //FREE ou VALID


    public ResourceRecord(String name, String type, String value, int ttl, int order,String origin, int index, String status) {
        this.name = name;
        this.type = type;
        this.value = value;
        this.ttl = ttl;
        this.order = order;
        this.origin = origin;
        this.index = index;
        this.status = status;
    }

    public String response (){
        return name+" "+type+" "+value+" "+ttl+ " "+order;
    }

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }

    public String getValue() {
        return value;
    }

    public int getTtl() {
        return ttl;
    }

    public int getOrder() {
        return order;
    }

    public String getOrigin() {
        return origin;
    }

    /*public int getTimeStamp() {
        return timeStamp;
    }*/

    public int getIndex() {
        return index;
    }

    public String getStatus() {
        return status;
    }
}
