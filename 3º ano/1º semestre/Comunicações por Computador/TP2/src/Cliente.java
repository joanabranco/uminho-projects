/**
 * Classe cliente
 * Autor: Alexandra, Inês e Joana
 * Data: 21/11/2022
 */


import java.io.IOException;
import java.net.*;
import java.lang.String;
import java.util.Arrays;

import static java.lang.Integer.parseInt;

public class Cliente {

    public static void comunicacao(int porta, String query_name, String query_type) throws IOException {
            InetAddress serverIP = InetAddress.getByName("localhost" );

            DNSMessage pdu = new DNSMessage(1,query_name,query_type);

            //cria socket cliente, udp datagrama
            DatagramSocket clientSocket = new DatagramSocket(0);

            //open datagrama com dados a enviar, tamanho, endereço IP, porta
            DatagramPacket sendPacket = new DatagramPacket(pdu.toString().getBytes(), pdu.toString().getBytes().length, serverIP, porta);
            //DatagramPacket sendPacket = new DatagramPacket("blablabal".getBytes(), "blablabal".getBytes().length, serverIP, porta);

            //cliente envia datagrama para servidor
            clientSocket.send(sendPacket);

            byte[] data = new byte[1024];

            //recebe pacote  do servidor
            DatagramPacket receivePacket = new DatagramPacket(data, data.length);

            //le pacote do servidor
            clientSocket.receive(receivePacket);

            //fazer parse do packet.getbytes
            //DNSMessage response = new DNSMessage(data);
            DNSMessage response = new DNSMessage(receivePacket.getData());

            System.out.println("FROM SERVER: " + response);
            clientSocket.close();
    }

    public static void main(String args[]) throws Exception {
        //cliente [ip servidor] [porta] [queryName] [queryType]
        //comunicacao(parseInt(args[0]),args[1],args[2]);

        comunicacao(5454,"winx.","NS");
    }
}

