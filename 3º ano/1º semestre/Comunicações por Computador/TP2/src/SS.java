import java.io.*;
import java.net.Socket;

public class SS {
    public static void main(String[] argv) throws Exception {

            Socket server = new Socket("127.0.0.1", 6777);
            BufferedReader input = new BufferedReader(new InputStreamReader(server.getInputStream()));

            PrintStream output = new PrintStream(server.getOutputStream());

            BufferedReader ServerMessage = new BufferedReader(new InputStreamReader(System.in));


            byte[] b = new byte[1024];
            System.out.println(" SS " + " " + server.getInetAddress()
                + ":" + server.getPort() + " IS CONNECTED ");
            String Message;
            while(true) {
                System.out.print("SS: "); //temos que por
                Message = ServerMessage.readLine();

                output.println(Message);
                System.out.println("SP: " + Message);

                Message = input.readLine();
                System.out.println("SS: " + Message);



                //entradas max 65535
                InputStream is = server.getInputStream();
            FileOutputStream fr = new FileOutputStream("src/info/data-base-files/new");
            is.read(b, 0, b.length);
            fr.write(b, 0, b.length);
            System.out.println("Receiving the File to from SP");
            // Call SendFile Method


        }
        }
    }



