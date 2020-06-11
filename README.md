# MetalIniOS
Metal tương tự như OpenGLES, được apple phát triển đanh riêng cho OS của nó (cải thiện tốc độ, hiệu năng) với low-level API, tương tác với GPU. 
Ứng dụng metal chạy trên thiết bị có chip Apple >= A7
# 1. Basic- Render Triangle
- Cần có MTLDevice để kết nối tới CPU, được sử dụng để tạo các Metal object khác (command queue, buffer, texture,...)
- CAMetalLayer: Subclass của CALayer, 1 view có nhiều layer chịu tránh nhiệm cụ thể. Để nhìn thấy được trên màn hình thì phải vẽ lên những layer này
- Vertex Buffer: Tất cả mọi object đều tạo thành từ n hình tam giác, gửi data về toạ độ (vertex data) qua GPU cần chuyển thành bufer
- Vertex Shader: nhận input là vertex phía trên (chương trình viết bằng MSL chạy trên GPU). 1 vertex shader được gọi 1 lần với mỗi đỉnh. Nhiệm vụ là biến đổi input (vertex ít nhất là chứa position - có thể có về màu sắc, texture coordinate,..) và trả về vị trí cuối cùng sau khi xử lý
- Fragment Shader: Khi hàm trên chạy xong thì thằng này được gọi cho mỗi fragment trên màn hình (coi như là những ô nhỏ được chỉ ra trên màn hình). Input của nó được nội suy từ output từ vertex shader. Công việc của nó là trả về color cuối cùng của fragment đang xử lý.
- Render Pipeline: Để kết hợp (khai báo vertex và fragment - các shader được biên dịch trước) từ sử dụng thằng này.
- Command Queue: Thể hiện danh sách công việc mà GPU cần thực hiện.

Để thấy được kết quả thì mỗi frame phải được vẽ đúng (TH này k có thay đổi thì vẽ 1 lần cũng ok).
Ở đây có thể dùng Display Link để gọi render mỗi frame.
- MTLRenderPassDescripor: cấu hình texture này hiển thị, clear color,...
- Command Buffer: danh sách các lệnh render mà cần làm trong frame này.
- Render Encoder: chỉ định dùng pepline state nào, vertex buffer nào. và vẽ.
- Command Buffer.present và commit để gửi task đến GPU.
# 2. Camera AR app
- Read video from galery, camera
- Merge video | image
- Color filter (single or mutil)
- Mutil consumer
- Sticker
- take picture
- Record video

<div>
   <img src="https://user-images.githubusercontent.com/28861842/84392585-c315b000-ac24-11ea-8e34-7ccfcd0d5658.PNG" width="250" height="425"> 
   <img src="https://user-images.githubusercontent.com/28861842/84392598-c5780a00-ac24-11ea-80c5-fd85f6a33144.PNG" width="250" height="425"> 
    <img src="https://user-images.githubusercontent.com/28861842/84392601-c610a080-ac24-11ea-97a7-91e99e0904dc.PNG" width="250" height="425"> 
 </div>
   <img src="https://user-images.githubusercontent.com/28861842/84392616-c90b9100-ac24-11ea-925a-275839f66f9b.PNG" width="250" height="425"> 
