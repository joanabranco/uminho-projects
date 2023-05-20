/**
 * Classe com o objetivo fazer a conexão entre o cliente e o servidor
 * Autor: Inês e Joana
 * Data: 16/11/2022
 */

import java.io.*;
import java.net.*;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;

import static java.lang.Integer.parseInt;

public class Server {
    private int porta;
    private String path;
    private static String dom;
    private static List<String> sp = new ArrayList<>();

    private static List<String> ss = new ArrayList<>();
    private static List<String> dd = new ArrayList<>();

    private static String db;

    private static String lg;
    private static String alllg;
    private static String st;
    private static String typeOfServer;
    private static String defaultTTL;
    private ResourceRecord [] cache; //lista de linhas de cache
    private static String log_file_name; //ficheiro de log


    public Server(int porta, String path) throws IOException {
        this.porta = porta;
        this.path = path; //path do ficheiro de configuração

        //alocar memória para a cache
        this.cache = new ResourceRecord[1000];

        //parse do ficheiro de configuração
        parseConfig(path);

        //só se for um SP é que faz parse do ficheiro de base de dados
        if (Objects.equals(typeOfServer, "SP"))
            parseDB(getDb());
            
             if (Objects.equals(typeOfServer, "SP")) {
            parseDB(getDb());
            Thread thread = new Thread(new Runnable() {
                public void run() {
                    BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
                    String input = null;
                    try {
                        input = reader.readLine();
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                    System.out.println(input);

                    //ler o ficheiro base de dados
                    //runParseDB("src/info/data-base-files/Beatrix.bd");

                    //cria socket de aceitação na porta 53
                    ServerSocket welcomeSocket = null;
                    try {
                        welcomeSocket = new ServerSocket(5353);
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }

                    while (true) {
                        //espera, no socket de aceitação por contacto do ss
                        Socket connectionSocket = null;
                        try {
                            connectionSocket = welcomeSocket.accept();
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }

                        //cria stream de entrada, ligado ao socket
                        BufferedReader inFromSS = null;
                        try {
                            inFromSS = new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }

                        //cria stream de saída, ligado ao socket
                        DataOutputStream outToSS = null;
                        try {
                            outToSS = new DataOutputStream(connectionSocket.getOutputStream());
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }

                        //lê a linha do socket
                        try {
                            input = inFromSS.readLine();
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                        //procurar na cache

                        //escreve linha para o socket
                        try {
                            outToSS.writeBytes("SP iniciou");
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }
                }
            });
            thread.start();
        }

        if (Objects.equals(typeOfServer, "SS")) {
            parseDB(getDb());

            Thread thread = new Thread(new Runnable() {
                public void run() {
                    BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
                    String input = null;
                    try {
                        input = reader.readLine();
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                    System.out.println(input);

                    //ler o ficheiro base de dados
                    //runParseDB("src/info/data-base-files/Beatrix.bd");

                    //cria socket de aceitação na porta 53
                    ServerSocket welcomeSocket = null;
                    try {
                        welcomeSocket = new ServerSocket(5353);
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }

                    while (true) {
                        //espera, no socket de aceitação por contacto do ss
                        Socket connectionSocket = null;
                        try {
                            connectionSocket = welcomeSocket.accept();
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }

                        //cria stream de entrada, ligado ao socket
                        BufferedReader inFromSS = null;
                        try {
                            inFromSS = new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }

                        //cria stream de saída, ligado ao socket
                        DataOutputStream outToSS = null;
                        try {
                            outToSS = new DataOutputStream(connectionSocket.getOutputStream());
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }

                        //lê a linha do socket
                        try {
                            input = inFromSS.readLine();
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                        //procurar na cache

                        //escreve linha para o socket
                        try {
                            outToSS.writeBytes("SS iniciou");
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }
                }
            });
            thread.start();
        }
    }
        /*else if (Objects.equals(typeOfServer, "SS"))
            transferenciaZona();*/

    }

    public static String getDb() {
        return db;
    }

    public static void parseConfig(String path) throws IOException {
        File file = new File(path);
        BufferedReader br = new BufferedReader(new FileReader(file));

        /*
        //inicialização das listas
        sp = new ArrayList<>();
        ss = new ArrayList<>();
        dd = new ArrayList<>();
         */

        String line=null;

        while ((line = br.readLine()) != null) { //começa a ler o ficheiro linha a linha
            String[] lineSplit = line.split(" ");

            if(!Objects.equals(lineSplit[0], "root") && !Objects.equals(lineSplit[0], "all")) dom = lineSplit[0]; //definir o domínio

            if (!(Objects.equals(lineSplit[0], "#")) && !(Objects.equals(lineSplit[0], ""))) { // evitar comentários e linhas vazias
                switch (lineSplit[1]) {
                    case "DB" -> {
                        db = lineSplit[2];
                        typeOfServer = "SP";
                    }
                    case "SP" -> {
                        sp.add(lineSplit[2]);
                        typeOfServer = "SS";
                    }
                    case "SS" -> ss.add(lineSplit[2]);
                    case "DD" -> dd.add(lineSplit[2]);
                    case "LG" -> {
                        if (Objects.equals(lineSplit[0], "all"))
                            alllg = lineSplit[2];
                        else lg = lineSplit[2];
                    }
                    case "ST" -> {
                        if (Objects.equals(lineSplit[0], "root")) st = lineSplit[2];
                    }
                }
            }
        }

    }

    public void parseDB(String path) throws IOException {
        File file = new File(path);
        BufferedReader br = new BufferedReader(new FileReader(file));

        String defaultDom = "";

        String line;

        int cl = 0; //variável que percorre as linhas de cache
        int flag = 0; //variável que indica fim do ficheiro

        //percorrer e preencher a cache
        while (cl < this.cache.length && flag == 0) {
            while ((line = br.readLine()) != null) { //começa a ler o ficheiro linha a linha
                String[] lineSplit = line.split(" ");

                if (!(Objects.equals(lineSplit[0], "#")) && !(Objects.equals(lineSplit[0], ""))) { // evitar comentários e linhas vazias

                    switch (lineSplit[1]) {
                        case "DEFAULT" -> {
                            if (Objects.equals(lineSplit[0], "@")) defaultDom = lineSplit[2];
                            if (Objects.equals(lineSplit[0], "TTL")) defaultTTL = lineSplit[2];
                        }
                        case "A", "CNAME" -> dom = lineSplit[0].concat(dom);

                        default -> {
                            //substitui as linhas que começam por @ pelo domínio por defeito
                            if ((Objects.equals(lineSplit[0], "@"))) lineSplit[0] = defaultDom;
                        }
                    }

                    // adicionar linhas à cache
                    if (lineSplit.length > 3 && !(Objects.equals(lineSplit[1], "DEFAULT"))) {
                        if (Objects.equals(lineSplit[3], "TTL"))
                            lineSplit[3] = defaultTTL;

                        // à medida que cada linha do ficheiro é lida, é adicionada à cache
                        this.cache[cl] = new ResourceRecord(lineSplit[0], lineSplit[1], lineSplit[2], parseInt(defaultTTL), cl, "FILE", cl, "VALID");
                        cl++;
                    }
                }
            }
            //this.cache[cl]= cacheLine; //adiciona a linha da cache, depois de ter sido definida
            flag = 1; //indicador de que chegou ao fim do ficheiro
        }
    }

    public void comunicUDP () throws IOException {
        //cria socket datagrama na porta 5353
        int porta=5454;
        try (DatagramSocket serverSocket = new DatagramSocket(porta)) {

            //atribui a um socket uma porta e um endereço
            //serverSocket.bind(new InetSocketAddress("localhost", porta));
            System.out.println("Estou à escuta na porta");
            while(true){

                //cria espaço para datagrama recebidos
                byte[] data = new byte[256];

                //fica à espera de receber o pacote
                DatagramPacket receivePacket = new DatagramPacket(data, data.length);

                // recebe datagrama
                serverSocket.receive(receivePacket);

                //transforma datagrama na estrutura de uma query
                DNSMessage pdu = new DNSMessage(receivePacket.getData());
                writeToLog(pdu);
                writeToAllLog(pdu);

                //obtem endereço IP
                InetAddress IPAddress = receivePacket.getAddress();

                //obtem o número da porta do transmissor
                int port = receivePacket.getPort();
                DNSMessage response = buildResponse(pdu);
                writeToLog(response);
                writeToAllLog(response);

                //onde é incluída a resposta à query recebida
                byte[] sendData = new byte[256];
                //manda a resposta em bytes
                sendData = response.toString().getBytes();

                //cria datagrama para enviar ao cliente
                DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress,port);

                //escreve o datagrama para envio no socket
                serverSocket.send(sendPacket);
            }
        }
    }

    private void writeToLog (DNSMessage query){
        try {
            BufferedWriter bw = new BufferedWriter(new FileWriter(lg, true));

            Instant currentTime = Instant.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss").withZone(ZoneId.systemDefault());
            String formattedTime = formatter.format(currentTime);

            String line = formattedTime +"  " + query + "\n";
            bw.write(line); //escreve no ficheiro log
            System.out.print(line); //imprime a linha no terminal

            bw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void writeToAllLog (DNSMessage query){
        try {
            BufferedWriter bw = new BufferedWriter(new FileWriter(alllg,true));

            Instant currentTime = Instant.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss").withZone(ZoneId.systemDefault());
            String formattedTime = formatter.format(currentTime);

            String line = formattedTime +"  " + query + "\n";
            bw.write(line); //escreve no ficheiro log

            bw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    private HashMap<String, List<Integer>> searchCache (String queryName, String queryType){
        //as chaves são do tipo(Response/Authorities/Extra Values) e contém os índices das linhas da cache
        HashMap<String,List<Integer>> search = new HashMap<>();

        List<Integer> l1 = new ArrayList<>();
        List<Integer> l2 = new ArrayList<>();
        List<Integer> l3 = new ArrayList<>();

        search.put("RV", l1);
        search.put("AV", l2);
        search.put("EV", l3);

        int i=0;

        //verificar que as linhas da cache têm conteúdo
        while (this.cache[i] != null && this.cache[i].getStatus().equals("VALID")) {

                //Response Values: faz match com o name e type da query
                if ((Objects.equals(queryName, cache[i].getName())) && (Objects.equals(queryType, cache[i].getType()))) {
                    search.get("RV").add(i);
                }
                //Authorities Values: faz match com o name e o type na cache é "NS"
                if ((Objects.equals(queryName, cache[i].getName())) && (Objects.equals("NS", cache[i].getType()))) {
                    search.get("AV").add(i);
                }
                //Extra Values: faz match com querys tipo A e com os parametros de Response e Authorities Values (em comum)
                if ((Objects.equals("A", cache[i].getType()))) {

                    //AQUIIIIIII falta verificar a 2ª parte
                    search.get("EV").add(i);

                }
            i++;
        }
        return search;
    }

    private DNSMessage buildResponse(DNSMessage query) {
        String name = query.getQueryName();
        String type = query.getQueryType();
        int msgId = query.getMessageId();
        String f;
        int nV=0,nA=0,nEV=0;
        List<String> responseValues=new ArrayList<>();
        List<String> authoritiesValues=new ArrayList<>();
        List<String> extraValues=new ArrayList<>();

        DNSMessage res = null;

        //verificar se name começa com ponto ou não
        char firstChar = name.charAt(0);
        if (firstChar != '.'){
            name = "."+name;
        }

        //procura na cache que devolve uma Hashmap
        HashMap<String,List<Integer>> searchC = searchCache(name, type);

        // criar nova mensagem DNS com a procura feita na cache
        if(searchC.containsKey("RV")){
            nV = searchC.get("RV").size();
            for(int i: searchC.get("RV")){
                responseValues.add(this.cache[i].response());
            }
        }
        if(searchC.containsKey("AV")){
            nA = searchC.get("AV").size();
            for(int i: searchC.get("AV")){
                authoritiesValues.add(this.cache[i].response());
            }
        }
        if(searchC.containsKey("EV")){
            nEV = searchC.get("EV").size();
            for(int i: searchC.get("EV")){
                extraValues.add(this.cache[i].response());
            }
        }
        f="A";

        //mensagem enviada para o cliente
        res = new DNSMessage(msgId,f,0,nV,nA,nEV,name,type,responseValues,authoritiesValues, extraValues);
        return res;
    }
     public void SP() throws Exception {

        // Here we define Server Socket running on port 900

        try (ServerSocket serverSocket = new ServerSocket(6777)) {
            System.out.println("SP is Starting in Port 6777");
            // Accept the Client request using accept method
            Socket clientSocket = serverSocket.accept();
           BufferedReader input = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));

            PrintStream output = new PrintStream(clientSocket.getOutputStream());

            BufferedReader ServerMessage = new BufferedReader(new InputStreamReader(System.in));

            System.out.println("Connected");
            String message;
            while(true){
                message= input.readLine();

                System.out.println("SP: " + message);

                System.out.println("SS: ");

                message = ServerMessage.readLine();

                output.println(message);

                System.out.println("Server: " + message);

                //ficheiro que vamos fazer copia 
                FileInputStream fl  = new FileInputStream("src/info/data-base-files/Beatrix.bd");
               byte b[] = new byte [1024];
               fl.read(b,0,b.length);
               OutputStream out = clientSocket.getOutputStream();
               out.write(b,0,b.length);}


        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    //quantas linhas tem um ficheiro, para sabermos as entradas
    public void lines(String path) throws IOException {
         FileInputStream stream = new FileInputStream(path);
         byte[] buffer = new byte[8192];
         int count = 0;
         int n;
         while ((n = stream.read(buffer)) > 0) {
             for (int i = 0; i < n; i++) {
                 if (buffer[i] == '\n') count++;
             }
         }
         stream.close();
         System.out.println("Number of lines: " + count);
        }



    

    public static void main(String args[]) throws Exception {
        //servidor [porta] [timeout] [debug] [ficheiro config]
        //Server server = new Server(parseInt(args[0]), args[1]);

        Server server = new Server(5454,"src/info/data-base-files/Beatrix.bd");
        //server.SP();
        server.comunicUDP();
    }
}
