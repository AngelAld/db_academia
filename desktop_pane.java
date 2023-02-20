
ImageIcon icon = new ImageIcon(getClass().getResource("/recursos/back.jpg"));
Image image = icon.getImage();

jDesktopPane1 = new javax.swing.JDesktopPane(){
 public void paintComponent(Graphics g){
 g.drawImage(image,0,0,getWidth(),getHeight(),this);
 }
};



import java.awt.Graphics;
import java.awt.Image;
import javax.swing.ImageIcon;








ImageIcon icon = new ImageIcon(imagePath);
            Image image = icon.getImage();

            

            @Override
            protected void paintComponent(Graphics g) {
                super.paintComponent(g);
                g.drawImage(newimage, 0, 0, this);
            }




