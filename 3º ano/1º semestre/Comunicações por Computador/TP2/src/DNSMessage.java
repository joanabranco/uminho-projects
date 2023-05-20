/**
 * Classe com o objetivo fazer a conexão entre o cliente e o servidor
 * Autor: Joana
 * Data: 16/11/2022
 */

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.lang.String;

import static java.lang.Integer.parseInt;

public class DNSMessage {
    //Campos de cabeçalho:
    private int messageId;
    private String flags;
    private int responseCode;
    private int nValues;
    private int nAuthorities;
    private int nExtraValues;

    //Campos de dados:
    private String queryName;
    private String queryType;
    private List<String> responseValues;
    private List<String> authoritiesValues;
    private List<String> extraValues;

    /**
     * Construtor capaz de receber todos os parâmetros para a estrutura de uma mensagem DNS
     */
    public DNSMessage(int id, String f, int rC, int nV, int nA, int nEV, String qN, String qT, List<String>rV, List<String>aV, List<String>eV){
        this.messageId = id;
        this.flags = f;
        this.responseCode = rC;
        this.nValues = nV;
        this.nAuthorities = nA;
        this.nExtraValues = nEV;
        this.queryName = qN;
        this.queryType = qT;
        this.responseValues = rV;
        this.authoritiesValues = aV;
        this.extraValues = eV;
    }

    /**
     * Construtor capaz de receber a mensagem em bytes e transformá-la para a estrutura de uma mensagem DNS
     */
    public DNSMessage(byte[] buffer){
        String line = new String(buffer); //cria string com o buffer, passa para string os bytes
        String[] lineSplit;
        lineSplit = line.split(" ");

        //Campos de cabeçalho:
        this.messageId = parseInt(lineSplit[0]); //messageId -> 16 bits
        this.flags = lineSplit[1]; //flags -> 3 bits
        this.responseCode = parseInt(lineSplit[2]); //responseCode -> 2 bits
        this.nValues = parseInt(lineSplit[3]); //nValues -> 8 bits
        this.nAuthorities = parseInt(lineSplit[4]); //nAuthorities -> 8 bits
        this.nExtraValues = parseInt(lineSplit[5]);//nExtraValues -> 8 bits



        //Campos de dados:
        this.queryName = lineSplit[6];
        this.queryType = lineSplit[7];
        this.responseValues = new ArrayList<>(); //response Values tem o comprimento de values
        if (nValues != 0){
            for(int j=0; j<nValues; j++)
                responseValues.add(lineSplit[8+j]);
        }
        this.authoritiesValues = new ArrayList<>(); //authorities Values tem o comprimento de authorities
        if (nAuthorities != 0){
            for(int j=0; j<nAuthorities; j++)
                authoritiesValues.add(lineSplit[8+nValues+j]);
        }
        this.extraValues = new ArrayList<>(); //extra values tem o comprimento de extra values
        if (nExtraValues != 0){
            for(int j=0; j<nExtraValues; j++)
                extraValues.add(lineSplit[8+nValues+nAuthorities+j]);
        }
    }

    public DNSMessage(int id, String query_name, String query_type) {
        this.messageId = id;
        this.flags = "Q";
        this.responseCode = 0;
        this.nValues = 0;
        this.nAuthorities = 0;
        this.nExtraValues = 0;
        this.queryName = query_name;
        this.queryType = query_type;
        this.responseValues = null;
        this.authoritiesValues = null;
        this.extraValues = null;
    }

    public int getMessageId() {
        return messageId;
    }

    public String getFlags() {
        return flags;
    }

    public int getResponseCode() {
        return responseCode;
    }

    public int getnValues() {
        return nValues;
    }

    public int getnAuthorities() {
        return nAuthorities;
    }

    public int getnExtraValues() {
        return nExtraValues;
    }

    public String getQueryName() {
        return queryName;
    }

    public String getQueryType() {
        return queryType;
    }

    public List<String> getResponseValues() {
        return responseValues;
    }

    public List<String> getAuthoritiesValues() {
        return authoritiesValues;
    }

    public List<String> getExtraValues() {
        return extraValues;
    }

    /**
     * Estrutura de uma mensagem DNS
     */
    public String toString() {
        return messageId + " "+
                flags +" "+
                responseCode +" "+
                nValues +" "+
                nAuthorities +" "+
                nExtraValues +" "+
                queryName +" "+
                queryType +" "+
                responseValues +" "+
                authoritiesValues +" "+
                extraValues;
    }
}

