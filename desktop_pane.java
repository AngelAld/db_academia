
import java.awt.Graphics;
import java.awt.Image;
import javax.swing.ImageIcon


ImageIcon icon = new ImageIcon(getClass().getResource("/recursos/back.jpg"));
Image image = icon.getImage()

 public void paintComponent(Graphics g){
 g.drawImage(image,0,0,getWidth(),getHeight(),this);
 }











