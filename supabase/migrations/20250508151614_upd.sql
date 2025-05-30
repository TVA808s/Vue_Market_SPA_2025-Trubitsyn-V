DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;

CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    avatar_url TEXT,
    full_name TEXT
);
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own profile" 
ON profiles 
FOR ALL 
USING (auth.uid() = id);

CREATE TABLE IF NOT EXISTS auth.users();

CREATE TABLE IF NOT EXISTS products (
    id SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY NOT NULL,
    stock SMALLINT NOT NULL,
    title TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL,
    price NUMERIC(6, 2) NOT NULL,
    description TEXT NOT NULL,
    rate NUMERIC(2, 1) NOT NULL DEFAULT 0 CHECK (rate BETWEEN 0 AND 5),
    image TEXT NOT NULL,
    discount SMALLINT NOT NULL DEFAULT 0 CHECK (discount BETWEEN 0 AND 100),
    color TEXT NOT NULL,
    brand TEXT NOT NULL
);


CREATE TABLE IF NOT EXISTS favourites (
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    product_id SMALLINT REFERENCES products(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, product_id)
);

ALTER TABLE favourites ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own favourites" 
ON favourites 
FOR ALL 
USING (auth.uid() = user_id);


CREATE TABLE IF NOT EXISTS orders (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    status TEXT NOT NULL CHECK (status IN ('pending', 'paid', 'shipped', 'canceled')) DEFAULT 'pending',
    total NUMERIC(10,2) NOT NULL CHECK (total >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own order" 
ON orders 
FOR ALL 
USING (auth.uid() = user_id);


CREATE TABLE IF NOT EXISTS order_items (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_title TEXT NOT NULL,
    product_image TEXT NOT NULL,
    price NUMERIC(7,2) NOT NULL CHECK (price >= 0),
    quantity SMALLINT NOT NULL CHECK (quantity > 0)
);

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own order items" 
ON order_items 
FOR ALL 
USING (
  EXISTS (
    SELECT 1 FROM orders 
    WHERE orders.id = order_items.order_id 
    AND orders.user_id = auth.uid()
  )
);


CREATE TABLE IF NOT EXISTS carts (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE carts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own cart" 
ON carts
FOR ALL 
USING (auth.uid() = user_id);


CREATE TABLE IF NOT EXISTS cart_items (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cart_id INT NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity SMALLINT NOT NULL CHECK (quantity > 0)
);

ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own cart items" 
ON cart_items 
FOR ALL 
USING (
  EXISTS (
    SELECT 1 FROM carts 
    WHERE carts.id = cart_items.cart_id 
    AND carts.user_id = auth.uid()
  )
);


DROP TRIGGER IF EXISTS on_change_position ON order_items;
DROP TRIGGER IF EXISTS on_change_quantity ON order_items;
DROP TRIGGER IF EXISTS on_change_price ON products;

-- -- ПРИ ИЗМЕНЕНИИ КОЛИЧЕСТВА ТОВАРА В ПОЗИЦИИ МЕНЯЕТСЯ ЦЕНА ПОЗИЦИИ
-- CREATE OR REPLACE FUNCTION set_price_at_order()
-- RETURNS TRIGGER AS $$
-- DECLARE 
--     product_price NUMERIC (6,2);
-- BEGIN 
--     SELECT price INTO product_price 
--     from products
--     WHERE id = NEW.product_id;
    
--     NEW.price_at_order := product_price * NEW.quantity;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
-- CREATE TRIGGER on_change_quantity
-- BEFORE INSERT OR UPDATE OF quantity ON order_items
-- FOR EACH ROW EXECUTE FUNCTION set_price_at_order();

-- -- ПРИ ИЗМЕНЕНИИ ЦЕНЫ ПОЗИЦИЙ МЕНЯЕТСЯ ЦЕНА ЗАКАЗА
-- CREATE OR REPLACE FUNCTION set_total()
-- RETURNS TRIGGER AS $$
-- DECLARE 
--     target_order_id SMALLINT;
-- BEGIN
--     target_order_id := COALESCE(NEW.order_id, OLD.order_id);
--     UPDATE orders
--     SET total = (
--         SELECT SUM(price_at_order) FROM order_items
--         WHERE order_id = target_order_id)
--     WHERE id = target_order_id;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
-- CREATE TRIGGER on_change_position
-- AFTER INSERT OR UPDATE OR DELETE ON order_items
-- FOR EACH ROW EXECUTE FUNCTION set_total();

-- -- ПРИ ИЗМЕНЕНИИ ЦЕНЫ ТОВАРА МЕНЯЕТСЯ ЦЕНА ПОЗИЦИИ
-- CREATE OR REPLACE FUNCTION set_price()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     UPDATE order_items
--     SET price_at_order = NEW.price * quantity
--     WHERE product_id = NEW.id;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
-- CREATE TRIGGER on_change_price
-- AFTER UPDATE OF price ON products
-- FOR EACH ROW EXECUTE FUNCTION set_price();

-- Индексы для ускорения БД
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_products_title ON products USING GIN(title gin_trgm_ops);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_order_items_order ON cart_items(cart_id);
CREATE INDEX idx_favourites_user ON favourites(user_id);

-- ИНСЕРТЫ
INSERT INTO products (stock, title, category, price, description, image, discount, color, brand, rate) VALUES
(12, 'Sony WH-1000XM3 Bluetooth Wireless Over Ear Headphones with Mic (Silver)', 'audio', 773, 'Digital noise cancelling : Industry leading Active Noise Cancellation (ANC) lends a personalized, virtually soundproof experience at any situation\r\nHi-Res Audio : A built-in amplifier integrated in HD Noise Cancelling Processor QN1 realises the best-in-class signal-to-noise ratio and low distortion for portable devices.\r\nDriver Unit : Powerful 40-mm drivers with Liquid Crystal Polymer (LCP) diaphragms make the headphones perfect for handling heavy beats and can reproduce a full range of frequencies up to 40 kHz.\r\nVoice assistant : Alexa enabled (In-built) for voice access to music, information and more. Activate with a simple touch. Frequency response: 4 Hz-40,000 Hz', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692947383286-714WUJlhbLS._SL1500_.jpg', 11, 'grey', 'sony', 4.5),
(4, 'Microsoft Xbox X/S Wireless Controller Robot White', 'gaming', 57, 'Experience the modernized design of the Xbox wireless controller in robot white, featuring sculpted surfaces and refined Geometry for enhanced comfort and effortless control during gameplay\r\nStay on target with textured grip on the triggers, bumpers, and back case and with a new hybrid D-pad for accurate, yet familiar input\r\nMake the controller your own by customizing button Mapping with the Xbox accessories app', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692255251854-xbox.jpg', 4, 'white', 'microsoft', 4.8),
(7, 'Logitech G733 Lightspeed Wireless Gaming Headset with Suspension Headband, LIGHTSYNC RGB, Blue VO!CE mic Technology and PRO-G Audio Drivers - White', 'gaming', 384, 'Total freedom with up to 20 m wireless range and LIGHTSPEED wireless audio transmission. Keep playing for up to 29 hours of battery life. 1 Play in stereo on PlayStation(R) 4.\r\nPersonalize your headset lighting across the full spectrum, 16. 8M colors. Play in colors with front-facing, dual-zone LIGHTSYNC RGB lighting and choose from preset animations or create your own with G HUB software.\r\nColorful, reversible suspension headbands are designed for comfort during long play sessions.\r\nAdvanced mic filters that make your voice sound richer, cleaner, and more professional. Customize with G HUB and find your sound.\r\nHear every audio cue with breathtaking clarity and get immerse in your game. PRO-G drivers are designed to significantly reduce distortion and reproduce precise, consistent, rich sound quality.\r\nSoft dual-layer memory foam that conforms to your head and reduces stress points for long-lasting comfort.\r\nG733 weighs only 278 g for long-lasting comfort.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692257709689-logitech heaphone.jpg', 3, 'white', 'logitech G', 3.9),
(3, 'Sony WH-1000XM5 Wireless Industry Leading Active Noise Cancelling Headphones, 8 Mics for Clear Calling, 30Hr Battery, 3 Min Quick Charge = 3 Hours Playback, Multi Point Connectivity, Alexa-Silver', 'audio', 362, 'Industry Leading noise cancellation-two processors control 8 microphones for unprecedented noise cancellation. With Auto NC Optimizer, noise cancelling is automatically optimized based on your wearing conditions and environment.\r\nIndustry-leading call quality with our Precise Voice Pickup Technology uses four beamforming microphones and an AI-based noise reduction algorithm\r\nMagnificent Sound, engineered to perfection with the new Integrated Processor V1\r\nCrystal clear hands-free calling with 4 beamforming microphones, precise voice pickup, and advanced audio signal processing.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692941008275-headphone3.jpg', 11, 'white', 'sony', 2.1),
(9, 'Urbanista Los Angeles Sand Gold - World’s 1st Solar Powered Hybrid Active Noise Cancelling with Mic Premium Wireless Headphones, Unlimited Playtime', 'audio', 265, 'Welcome to the dawn of a new era with URBANISTA LOS ANGELES, the world’s first solar-charging premium wireless headphoneS powered by Powerfoyle solar cell material. Using ADVANCED GREEN TECHNOLOGY, Los Angeles converts all light, outdoor and indoor, into energy to deliver virtually infinite playtime. Los Angeles never stops charging when exposed to light, providing you with a nonstop audio experience. With Los Angeles, you’re always in complete control of your audio experience. Just the press of a button activates advanced hybrid Active Noise Cancelling, instantly reducing unwanted background noise, or switches on Ambient Sound Mode so you can stay aware of important surrounding sounds.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691056487173-headphon2.jpg', 19, 'yellow', 'urbanista', 2),
(0, 'Xiaomi Wired in-Ear Earphones with Mic, Ultra Deep Bass & Metal Sound Chamber (Blue)', 'audio', 5, 'Ergonomically angled to fit perfectly in your ear canal that provides long lasting comfort for every day usage.\r\nFeatures 1.25 meter long cable & L-shaped 3.5mm jack to connect with your phone. Due to the L-shape, the connector will deliver a strong & durable life. Earphones are compatible with Android, iOS & Windows devices with jack.\r\nPowerful 10 mm drivers & aluminum sound chamber for super extra bass and clear sound for the best music & calling experience.\r\nHigh-quality silicone earbuds, which are gentle on skin without compromising the comfortable fit on the ears.\r\nIn-line microphone with a durable multi-function button to play/pause your music, and answer/end your calls, all with just one tap.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691057474498-earphone.jpg', 0, 'blue', 'xiaomi', 4.4),
(12, 'boAt Rockerz 370 On Ear Bluetooth Headphones with Upto 12 Hours Playtime, Cozy Padded Earcups and Bluetooth v5.0, with Mic (Buoyant Black)', 'audio', 12, 'Rockerz 370 come equipped with latest Bluetooth v5.0 for instant wireless connectivity\r\nThe powerful 300mAh battery provides up to 8 Hours of audio bliss\r\n40mm Dynamic Drivers supply immersive High Definition sound\r\nThe headset has padded earcups for a comfortable experience\r\nThe headphone has been ergonomically and aesthetically designed for a seamless experience\r\nOne can connect to Rockerz 370 via dual modes for connectivity in the form of Bluetooth and AUX\r\n1 year warranty from the date of purchase.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691057718636-headphone5.jpg', 0, 'black', 'boat', 2.9),
(8, 'Samsung Galaxy S21 FE 5G (Lavender, 8GB, 128GB Storage)', 'mobile', 434, 'Pro-grade Camera with AI Single Take, Portrait Mode, Night Mode and 30X Space zoom. Dual Recording: Film in both wide and selfie angles at the same time | 12MP F1.8 Main Camera (Dual Pixel AF & OIS) + 12MP UltraWide Camera (123° FOV) + 8MP Telephoto Camera (3x Optic Zoom, 30X Space Zoom, OIS) | 32 MP F2.2 Front Camera.\r\n16.28cm (6.4-inch) Dynamic AMOLED 2X Display with120Hz Refresh rate for Smooth scrolling. Intelligent Eye Comfort Shield, New 19.5:9 Screen Ratio with thinner bezel, 1080x2340 (FHD+) Resolution.\r\n5G Ready with Octa-core Exynos 2100 (5nm) Processor. Android 12 operating system. Dual Sim.\r\nIconic Contour Cut Design with 7.9 mm thickness. Gorilla Glass Victus and IP68 Water Resistant .', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691073671025-galaxy S21 FE.jpg', 9, 'yellow', 'samsung', 3.8),
(9, 'Amkette EvoFox Elite Ops Wireless Gamepad for Android TV | Google TV | 8+ Hours of Play Time | Zero Lag Connectivity Upto 12 Feets | USB Extender for TV Included | - Dusk Grey', 'gaming', 18, 'The EvoFox Elite Ops Wireless Gamepad with Type C Charging is the ideal Android TV Gamepad. With all Android TVs supporting at least basic Gaming, a Gamepad at home is a must. Use the provided USB Extender Cable on your TV to ensure optimal wireless performance.\r\nThis Wireless Controller also supports Windows with X input and D input modes, and PS3s. It automatically detects and changes the gamepad mode based on your system. Simply Plug and Play!\r\nThe Elite Ops features Digital Triggers (not Analog), Accurate 360 degree concave thumbsticks, a Precise 8 way floating D-Pad. The gamepad also features dual rumble Vibration motors (for PC and PS3 only) and an easy to use Turbo Mode.\r\nThe gamepad comes with a Type C charging port and the 400mAh Rechargeable battery ensures 8 hours of non stop gameplay. The ergonomic and robust design with anti-sweat matte finish makes it easy on your hands, but tough on your enemies.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1694100438525-51Prg4Smx-L._SL1500_.jpg', 3, 'gray', 'Amkette', 3.4),
(5, 'Samsung Galaxy S22 5G (Phantom White, 8GB RAM, 128GB Storage) with No Cost EMI/Additional Exchange Offers', 'mobile', 760, 'Pro-grade Camera that lets you make your nights epic with Nightography: It’s our brightest innovation yet. The sensor pulls in more light, the Super Clear Glass dials down lens flare, and fast-acting AI delivers near-instant intelligent processing.\r\nVisionBooster outshines the sun: Stunning 120Hz Dynamic AMOLED 2X display is crafted specifically for high outdoor visibility, keeping the view clear in bright daylight.\r\n4nm processor, our fastest chip yet: Our fastest, most powerful chip ever. That means, a faster CPU and GPU compared to Galaxy S21 Ultra. It’s an epic leap for smartphone technology.\r\nSleek design in a range of colors lets you express yourself how you like. The slim bezels flow into a symmetrical polished frame for an expansive, balanced display. Corning Gorilla Glass Victus+ on the screen and back panels.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691074519203-galaxy S22 5G.jpg', 29, 'white', 'samsung', 4.9),
(14, 'Samsung Galaxy S22 Ultra 5G (Burgundy, 12GB, 256GB Storage)', 'mobile', 1147, 'The first Galaxy S with embedded S Pen. Write comfortably like pen on paper, turn quick notes into legible text and use Air Actions to control your phone remotely. Improved latency in Samsung Notes makes every pen stroke feel as natural as ink on paper — and you can convert those hastily written ideas into legible text.\r\n5G Ready powered by Galaxy’s first 4nm processor. Our fastest, most powerful chip ever. That means, a faster CPU and GPU compared to Galaxy S21 Ultra. It’s an epic leap for smartphone technology.\r\nThe Dynamic AMOLED 2x display improves outdoor visibility with up to 1750 nits in peak brightness.* And the 120Hz adaptive refresh rate keeps the scroll smooth, adjusting to what''s on screen for an optimized view.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691074776147-galaxy S22 ultra 5G.jpg', 29, 'pink', 'samsung', 1.2),
(8, 'Poco by Xiaomi F1 Steel Blue, 6GB RAM, 64GB Storage', 'mobile', 132, '2MP+5MP dual camera | 20MP front facing camera\r\n15.69 centimeters (6.18-inch) IPS (in-cell) multi-touch capacitive touchscreen with 2246 x 1080 pixels resolution, 403 ppi pixel density\r\nMemory, Storage & SIM: 6GB RAM, 64GB internal memory expandable up to 128GB | Dual SIM (nano+nano) dual-standby (4G+4G)\r\nAndriod Oreo v8.1 operating system with 2.8GHz Qualcomm Snapdragon 845 octa core processor, 8xKyro cores/10 nm architecture\r\n4000mAH lithium-ion battery with quick charge 3.0 to keep you going all-day long\r\n1 year manufacturer warranty for device and 6 months manufacturer warranty for in-box accessories including batteries from the date of purchase', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691078463674-poco f1.jpg', 0, 'blue', 'xiaomi', 4.1),
(4, 'Samsung Galaxy M14 5G (Smoky Teal, 6GB, 128GB Storage)', 'mobile', 187, '16.72 centimeters (6.6-inch) LCD, FHD+ resolution with 1080 x 2408 pixels resolution, 401 PPI with 16M color\r\n50MP+2MP+2MP Triple camera setup- True 50MP (F1.8) main camera + 2MP (F2.4) + 2MP (F2.4)| 13MP (F2.0) front camera\r\nSuperfast 5G with 13 5G Bands, Powerful Exynos 1330 Octa Core 2.4GH 5nm processor with Letest Android 13,One UI Core 5.0,\r\n6000mAH lithium-ion battery, 1 year manufacturer warranty for device and 6 months manufacturer warranty for in-box accessories including batteries from the date of purchase\r\nGet up to 2 times of Android Updates & 4 times of Security Updates with Samsung Galaxy M14 5G.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691075307831-galaxy M14 5G.jpg', 19, 'grey', 'samsung', 3.9),
(1, 'Apple iPhone 14 (128 GB) - Blue', 'mobile', 809, '15.40 cm (6.1-inch) Super Retina XDR display\r\nAdvanced camera system for better photos in any light\r\nCinematic mode now in 4K Dolby Vision up to 30 fps\r\nAction mode for smooth, steady, handheld videos\r\nVital safety technology — Crash Detection calls for help when you can’t\r\nAll-day battery life and up to 20 hours of video playback\r\nIndustry-leading durability features with Ceramic Shield and water resistance', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691075659827-iPhone 14.jpg', 9, 'blue', 'apple', 5.0),
(0, 'Apple iPhone 14 Pro Max (256 GB) - Deep Purple', 'mobile', 1810, '17.00 cm (6.7-inch) Super Retina XDR display featuring Always-On and ProMotion\r\nDynamic Island, a magical new way to interact with iPhone\r\n48MP Main camera for up to 4x greater resolution\r\nCinematic mode now in 4K Dolby Vision up to 30 fps\r\nAction mode for smooth, steady, handheld videos\r\nAll-day battery life and up to 29 hours of video playback\r\nVital safety technology — Crash Detection can detect a severe car crash and call for help', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691075831385-iPhone 14 pro max.jpg', 0, 'purple', 'apple', 4.6),
(6, 'Apple iPhone 14 Pro (256 GB) - Gold', 'mobile', 1546, '15.54 cm (6.1-inch) Super Retina XDR display featuring Always-On and ProMotion\r\nDynamic Island, a magical new way to interact with iPhone\r\n48MP Main camera for up to 4x greater resolution\r\nCinematic mode now in 4K Dolby Vision up to 30 fps\r\nAction mode for smooth, steady, handheld videos\r\nAll-day battery life and up to 23 hours of video playback\r\nVital safety technology — Crash Detection calls for help when you can’t', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691076020478-iPhone 14 pro.jpg', 0, 'yellow', 'apple', 3.8),
(20, 'Ant Esports GP310 Wireless Gamepad, Compatible for PC & Laptop (Windows 10/8 /7, Steam) / PS3 / Android', 'gaming', 59, 'Compatibility – PC / Laptop Computer(Windows 10/8/7/XP), Steam, Play Station 3(PS3), Android Mobile Phone*/Tablet*/the device needs support OTG function( * not all Android phones are supported, check your device before purchasing for Android devices, Limited games can play on it which are supported to android games)\r\nExcellent Design – Equipped with 2.4Ghz wireless technology, supports up to 10m range | Wear-resistant Anti-slip Joystick | Cool Appearance | Comfortable Grip\r\nPlug & Play -Only for PC games supporting X input mode, Android mobile games supporting Android mode, Play Station 3. No need to install drivers except for Windows XP\r\nFeature - Multi-mode : X input, D input, Android, PS3 | Vibration Feedback Function', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692255692675-ant sport.jpg', 3, 'black', 'ant esports', 4.2),
(2, 'Logitech G502 Lightspeed Wireless Gaming Mouse, 25K Hero Gaming Sensor, 25600 DPI, RGB, Ultra-Light, 11 Programmable Buttons, Long Life Battery, PowerPlay-Compatible, PC - Black', 'gaming', 20, 'COLORFUL LIGHTSYNC RGB : Play in colour with our most vibrant LIGHTSYNC RGB featuring colour wave effects that are customisable across 16.8 million colours. 8,000 DPI sensor.\r\nCLASSIC,GAMER TESTED DESIGN : Play comfortably and with total control. The simple 6-button layout and classic gaming shape form a comfortable, time-tested and loved design\r\nMECHANICAL SPRING BUTTON TENSIONING: Primary buttons are mechanical and tensioned with durable metal springs for reliability, performance and an excellent feel\r\nCUSTOMIZABLE SETTINGS : To suit the sensitivity you like with Logitech G HUB gaming software and cycle easily through up to 5 DPI settings; SYSTEM REQUIREMENTS : Windows 7 or later, macOS 10.11 or later, Chrome OSTM, USB port, Internet access for Logitech Gaming Software (optional)\r\nStyle Name: G102 2nd Gen', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692257315660-logitech.jpg', 9, 'black', 'logitech', 3.9),
(0, 'Sony PS5 PlayStation Console+God Of War Ragnarok | Standard Edition | PS5 Game (PlayStation 5)', 'gaming', 708, 'Maximize your play sessions with near instant load times for installed PS5 games.\r\nThe custom integration of the PS5 console systems lets creators pull data from the SSD so quickly that they can design games in ways never before possible.\r\nImmerse yourself in worlds with a new level of realism as rays of light are individually simulated, creating true-to-life shadows and reflections in supported PS5 games.\r\nPlay your favorite PS5 games on your stunning 4K TV.\r\nThose who break fate: Atreus seeks knowledge to help him understand the prophecy of Loki and what role he is to play in Ragnarök. Kratos must decide whether he will be chained by the fear of repeating his mistakes or break free of his past to be the father Atreus needs.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692459170997-61iHq6qV0gL._SL1422_.jpg', 11, 'white', 'sony', 3.8),
(5, 'Wireless Bluetooth Headphones', 'electronics', 129, 'Noise-cancelling over-ear headphones with 30h battery', 'https://cdn1.ozone.ru/s3/multimedia-l/6216636393.jpg', 15, 'black', 'Sony', 4.7),
(12, 'Cotton T-Shirt', 'clothing', 24, 'Premium organic cotton crew neck t-shirt', 'https://cdn1.ozone.ru/s3/multimedia-i/c600/6703854102.jpg', 0, 'white', 'H&M', 4.3),
(25, 'Electric Kettle', 'kitchen', 45, '1.7L stainless steel fast-boiling kettle', 'https://i.ebayimg.com/images/g/x6AAAOSwN6VelHdv/s-l1600.jpg', 10, 'grey', 'Philips', 4.5),
(3, 'Running Shoes', 'sports', 89, 'Lightweight mesh sneakers with air cushion', 'https://i.pinimg.com/originals/40/de/69/40de693a197132d3b1da64aa14d45c0e.jpg', 20, 'blue', 'Nike', 4.8),
(15, 'Smart Watch', 'electronics', 199, 'Fitness tracker with heart rate monitor', 'https://avatars.mds.yandex.net/get-mpic/6458782/img_id3039830389997932666.jpeg/orig', 25, 'grey', 'Apple', 4.9),
(20, 'Novel "The Silent Forest"', 'books', 14, 'Bestselling mystery thriller paperback', 'https://i.ytimg.com/vi/vRo3cjc9cG4/maxresdefault.jpg', 0, 'beige', 'Penguin', 4.6),
(4, 'Ceramic Coffee Mug', 'kitchen', 12, '350ml handmade ceramic mug', 'https://avatars.mds.yandex.net/get-mpic/15339463/2a00000193a8421611ae01f473c70761efb7/orig', 5, 'beige', 'IKEA', 4.4),
(3, 'Yoga Mat', 'sports', 34, '6mm thick eco-friendly mat', 'https://avatars.mds.yandex.net/i?id=a34fc8b816c4e1f366d062bd334b02e3_l-4569510-images-thumbs&n=13', 0, 'purple', 'Adidas', 4.2),
(6, 'Wireless Mouse', 'electronics', 29, 'Ergonomic optical silent mouse', 'https://picsum.photos/204/304', 10, 'black', 'Logitech', 4.5),
(9, 'Denim Jacket', 'clothing', 79, 'Vintage wash trucker jacket', 'https://st-levis.mncdn.com/Content/media/ProductImg/original/7233405670-the-trucker-jacket-tr-indigo-erkek-trucker-637393943233766323.jpg', 30, 'blue', 'Levi''s', 4.7),
(50, 'Panasonic RB-M300B Deep Bass Wireless Bluetooth Immersive Headphones with XBS DEEP and Bass Augmentation (Sand Beige), RB-M300B-C', 'audio', 289, 'ULTRA-LOW BASS RESPONSE Enjoy powerful deep bass, without compromising the depth and balance of the track\r\nWIRELESS PERFORMANCE Reliable Bluetooth connectivity with built-in microphone\r\n50 HOURS PLAYBACK On a full four-hour charge, plus quick 15min charge for 3 hours playback\r\nDUO POWER DRIVERS Two 40 mm Neodymium driver units provide deep, yet delicate bass sound\r\nHIGH-COMFORT FIT Soft cushioned headband and earpads fit gently over the ears for hours of anytime anywhere comfort', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691056086962-headphone.jpg', 15, 'white', 'panasonic', 4.7),
(120, 'Sony WH-CH520, Wireless On-Ear Bluetooth Headphones with Mic...', 'audio', 54, 'With up to 50-hour battery life and quick charging, you’ll have enough power for multi-day road trips and long festival weekends.\r\nGreat sound quality customizable to your music preference with EQ Custom on the Sony | Headphones Connect App.\r\nBoost the quality of compressed music files and enjoy streaming music with high quality sound through DSEE.\r\nDesigned to be lightweight and comfortable for all-day use.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692941955003-headphone2.jpg', 3, 'grey', 'sony', 4.5),
(80, 'boAt Stone 180 5W Bluetooth Speaker with Upto 10 Hours Playback...', 'audio', 13, 'Stone 180 comes equipped with 1.75\" Dynamic Drivers for powerful immersive sound\r\nIts power packed 800mAh battery ensures extended indulgence in musical bliss with up to 10 hours of play time, Charging Time : 1.5 Hours\r\nThe speaker offers 5W of premium High Definition sound, Frequency Response - 70Hz-70kHz\r\nStone 180 supports instant wireless connectivity with latest Bluetooth v5.0\r\nConnect two Stone 180’s and turn the scene right around with double the volume at the same clarity level, get the party started anywhere, anytime with the boAt Stone 180\r\nIt is IPX7 rated which offers protection against sweat and water.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692943845065-71vI6nfLtYL._SL1500_.jpg', 2, 'black', 'boat', 4.3),
(45, 'Mivi Play Bluetooth Speaker with 12 Hours Playtime...', 'audio', 10, 'Studio Grade Sound: The Mivi Play Bluetooth speaker delivers a deep and powerful sound with a solid bass to amplify your beats and make you fall in love with every note.\r\nPlay it non-stop: The Mivi Play wireless speaker packs a battery life of up to 12 long hours on a single charge to keep your party going on and on till the break of dawn.\r\nPremium Brag Worthy Design: The Mivi Play portable wireless speaker comes with a sleek design, that makes it numero uno choice for those who love their music in private or with a couple friends!\r\nConnections made stronger: Nobody likes it when their music gets interrupted. Mivi Play’s latest and advanced Bluetooth 5.0 lets you enjoy seamless wireless connectivity, keeping your connections strong and uninterrupted. Now that’s the next generation of wireless bluetooth speakers!', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692944238682-61UJnlIHF9S._SL1500_.jpg', 3, 'black', 'mivi', 4.6),
(30, 'JBL Go 2, Wireless Portable Bluetooth Speaker with Mic...', 'audio', 24, '"JBL Signature Sound\r\n5 Hours of Playtime under optimum audio settings\r\nWireless Bluetooth Streaming\r\nIPX7 Waterproof design, Battery Type Lithium-ion polymer (3.7V, 730mAh), Charging time (hrs) 2.5\r\nBuilt-in Noise-cancelling Speakerphone\r\nAudio cable input\r\nWhat’s in the box: 1 x JBL GO 2, 1 x Micro USB cable for charging, 1 x Safety Sheet, 1 x Quick Start Guide, 1 x Warranty Card', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692944486283-8193DNNjZFS._SL1500_.jpg', 4, 'blue', 'JBL', 4.8),
(90, 'Mivi Duopods A25 Bluetooth Truly Wireless in Ear Earbuds...', 'audio', 12, 'Made in India : From design to manufacturing, Mivi DuoPods A25 is proudly made in India. It is built locally to compete globally..Note : If the size of the earbud tips does not match the size of your ear canals or the headset is not worn properly in your ears, you may not obtain the correct sound qualities or call performance. Change the earbud tips to ones that fit more snugly in your ears\r\nConcert In Your Ears: Need to get away from the ever noisy city life? Simply tune in to the Mivi DuoPods A25 and immerse yourself in the high-quality sound of these wireless earbuds.\r\nStudio Quality Sound: The Mivi DuoPods A25 has a studio quality sound output which makes it one of the best wireless earbuds in the market or anything youve ever tried.\r\n', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692945068061-61yTSVeLebS._SL1500_.jpg', 6, 'white', 'Mivi', 4.4),
(25, 'soundcore by Anker Space Q45 Adaptive Noise Cancelling Headphones...', 'audio', 415, '98% Less Noise for Your Journey: The fully-upgraded noise cancelling system targets and blocks out a wider range of noises—from plane engines to crying babies. So wherever you go, you can enjoy your personal space.\r\nMake Every Space Your Own: Whether youre indoors, outdoors, commuting, or on a flight, Space Q45s adaptive noise cancelling will automatically select a suitable level to match your location. Also, use the app to choose 1 of 5 noise cancelling levels.\r\nIdeal for Traveling: 50 hours of playtime in noise cancelling mode will cover an around-the-world flight without needing to recharge. In normal mode, get up to 65 hours of playtime and if you are low on battery, charge for 5 minutes for 4 hours of playtime.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691056348236-headphone3.jpg', 29, 'blue', 'soundcore', 4.9),
(15, 'Marshall Uxbridge Airplay Multi-Room Wireless Speaker with Alexa...', 'audio', 266, 'Loud just got smaller. Uxbridge Voice is engineered to create a thunderous sound from itscompact frame. An advanced setup with high-end components come together to producescreaming highs\r\nConsider this speaker your backstage pass to every song on the planet. Access to the world’s music has never been easier, just ask Alexa to play music.Frequency Range 54-20,000 Hz\r\nFill your home with immersive sound by building a multi-room system with Amazon Echo andother supported Alexa built-in speakers or Airplay 2 enabled speakers.\r\nYou can play music, get answers, manage everyday tasks and easily control smart devicesaround your home – just by using your voice. Alexa can help you listen to your favouritesong, turn up the volume', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692946110280-81WIcjaGp2L._SL1500_.jpg', 9, 'white', 'Marshall', 4.7),
(10, 'Bang & Olufsen Beosound Balance Wireless Multiroom Speaker...', 'audio', 5804, 'Beosound Balance is a wireless speaker with a cutting-edge audio engine, made to deliver a powerful, dynamic yet sophisticated sound experience for larger living spaces. It is designed for design-conscious consumers preferring a display-friendly interior inspired speaker. One that does not have to take up valuable floor space in the home. Placement up against the wall is ideal for optimal listening, whether from room-filling to focused sound modes. Inspired by interior objects and the use of soft and well-curated materials like natural solid oak wood, seamlessly knitted textile and precision-crafted aluminium components, Beosound Balance is the manifestation of the perfect balance between elegant and approachable beauty and unspoiled, pure sound performance.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692946673658-91xz5VkenTL._SL1500_.jpg', 21, 'pink', 'Bang & Olufsen', 5.0),
(200, 'JBL Tune 720BT Wireless Over Ear Headphones with Mic...', 'audio', 63, 'JBL PURE BASS SOUND: The JBL Tune 720BT utilizes the renowned JBL Pure Bass sound, the same technology that powers the most famous venues all around the world.\r\nUP TO 76H BATTERY LIFE: Get the most out of your entertainment with up to 76 hours of wireless listening pleasure, and easily recharge the battery in as little as 2 hours using the convenient Type-C USB cable.\r\nQUICK CHARGE: Running low on battery? With a quick 5-minute recharge, you can get an additional 3 hours of music playback to keep the beats going\r\nJBL HEADPHONES APP: By downloading the JBL Headphones app, you can personalize the sound of your Tune 720BT headphones according to your preferences with ease, using the EQ settings. Moreover, the app offers voice prompts in your desired language to guide you through the different headphone features', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691055458260-headphone.jpg', 9, 'blue', 'jbl', 4.6),
(30, 'Sony SA-SW5 300W Wireless Subwoofer for HT-A9 and HT-A7000 - Black', 'audio', 629, 'Experience powerful, booming sound with the SW5 wireless subwoofer for use with HT-A9 & A7000 soundbars.\r\nDeep bass and further clearness and fidelity\r\nWireless connectivity and quick and easy setup\r\nAdd depth with 300W powerful bass', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692947684843-61T7iilajhL._SL1200_.jpg', 9, 'black', 'sony', 4.5),
(25, 'DENON Home 350 Wireless Speaker - Powerful Room Filling Sound...', 'audio', 919, 'JBL DEEP BASS SOUND: Feel the sound with the Deep Bass powered by the 8mm Dynamic drivers and add fun to your routine.\r\nUPTO 20 HOURS OF PLAYTIME: With 5 hours in the earbuds and 15 hours in the case, the JBL Wave 200TWS don’t drop until you do.\r\nQUICK CHARGE: Running Low on Charge, worry not. A quick 15min of charge provides you with playtime upto an Hour.\r\nDUAL CONNECT TECHNOLOGY: With the Dual Connect Technology on the Wave 200 TWS, take calls or listen to music with either bud (or both). Choose which one to use and leave the other one in the case to save battery life.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692947856684-81xoxBiCcjL._SL1500_.jpg', 9, 'white', 'Denon', 4.7),
(80, 'JBL Wave 200 Wireless Earbuds (TWS) with Mic...', 'audio', 24, 'DENON HOME 350 The Denon Home series fills your home with superb wireless sound. The powerful Denon Home 350 with its amazing sound stage takes your music into every corner, even in large rooms. Pair it with another Denon Home 350 for stereo or combine it with other HEOS Built-in products.\r\nUPGRADE TO SUPERB WIRELESS SOUND Enjoy exceptional sound with the Denon Home Series. Stream your favourite music effortlessly and make use of quick pre-selections with just a gentle touch. Experience impressive acoustic performance, based on 110 years of sound innovation.\r\nA MIGHTY PERFORMER. Like every Denon the Denon Home 350 is built to deliver best-in-class audio quality. With advanced acoustic hardware, expertly tuned digital signal processing and premium drivers, the Denon Home 350 delivers the clearest highs and deepest lows. Experience excellence in every beat.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691055343505-earbud.jpg', 0, 'black', 'jbl', 4.3),
(45, 'Sony WF-C700N Bluetooth Truly Wireless Lightest Active Noise Cancellation...', 'audio', 108, 'Lightest Earbuds : Focus on your music for as long as you like. These small, lightweight earbuds have an ergonomic surface design for all-day comfort, even for smaller ears.\r\nNoise Cancellation: Cancel out background noise with Noise Sensor Technology or use the Ambient Sound Mode to stay connected to your natural surroundings. Headphones Connect app to control your listening experience.\r\nMultipoint connection: For total convenience, these Bluetooth headphones can be paired with two Bluetooth devices at the same time. So when call comes in your headphones know which device is ringing and connects to the right one automatically.\r\nListen all day, charge in minutes: Enjoy up to 15 hours of listening thanks to the handy charging case.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1692939913875-earphone1.jpg', 9, 'black', 'sony', 4.8),
(15, 'New Apple AirPods Max - Pink', 'audio', 723, 'Apple-designed dynamic driver provides high-fidelity audio\r\nActive Noise Cancellation blocks outside noise, so you can immerse yourself in music\r\nTransparency mode for hearing and interacting with the world around you\r\nSpatial audio with dynamic head tracking provides theater-like sound that surrounds you\r\nComputational audio combines custom acoustic design with the Apple H1 chip and software for breakthrough listening experiences\r\nDesigned with a knit-mesh canopy and memory foam ear cushions for an exceptional fit', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1691053838595-headphone2.jpg', 9, 'pink', 'apple', 4.9),
(60, 'Redmi 80 cm (32 inches) HD Ready Smart LED Fire TV...', 'tv', 138, 'Resolution: HD Ready (1366x768) | Refresh Rate: 60 hertz | 178 wide viewing angle\r\nConnectivity: Dual Band Wi-Fi (2.4 GHz/ 5 GHz) | 2 HDMI ports to connect set top box, gaming consoles, DVD or Blu-ray Players | 2 USB ports to connect hard drives and other USB devices | ARC | Bluetooth 5.0 | Ethernet | 3.5mm earphone Jack\r\nSound: 20 Watts Output | Dolby Audio | DTS Virtual: X | DTS-HD\r\nSmart TV Features : Fire TV Built-In | Supported Apps: Prime Video | Netflix | Disney+ Hotstar | YouTube | 12000+ apps from App Store | Voice Remote with Alexa | DTH Set-Top Box Integration to switch between DTH TV Channels and OTT apps from home screen | Display Mirroring - Airplay & Miracast | Quad core ARM Cortex-A35 CPU @ 2.0GHz | 1GB RAM + 8GB Internal Storage\r\nDisplay: Metal bezel-less Screen | Vivid Picture Engine\r\nRecommendation: We recommend using 1.5V Alkaline AAA Batteries in your Alexa Voice Remote for a steady performance.', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1694154515879-819Lw2PE8tL._SL1500_.jpg', 7, 'black', 'redmi', 4.4),
(40, 'Samsung 108 cm (43 inches) Crystal iSmart 4K Ultra HD Smart LED TV...', 'tv', 396, 'Smart TV Features : Supported apps: Netflix, Prime Video, YouTube, etc., Screen mirroring, Universal Guide, Media Home, Tap View, Mobile Camera Support, AI Speaker, Easy Setup, App Casting, Wireless DeX, SmartThings, Smart Hub, IoT Sensor, Web Browser', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1694154827301-81+JXgPUDLL._SL1500_.jpg', 9, 'black', 'samsung', 4.6),
(35, 'Mi 125 cm (50 inches) X Series 4K Ultra HD Smart Android LED TV...', 'tv', 384, 'Resolution: 4K Ultra HD (3840 x 2160) | Refresh Rate: 60 hertz | 178° wide viewing angle\r\nConnectivity: Dual Band Wi-Fi (2.4 GHz/ 5 GHz) | 3 HDMI ports to connect latest gaming consoles, set top box, Blu-ray Players | 2 USB ports to connect hard drives and other USB devices | ALLM | eARC | Bluetooth 5.0 | Optical | Ethernet | 3.5mm earphone Jack\r\nSound: 30 Watts Output | Dolby Audio', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1694155239807-81UT46-gwRL._SL1500_.jpg', 11, 'black', 'mi', 4.5),
(20, 'Acer 126 cm (50 inches) V Series 4K Ultra HD Smart QLED Google TV...', 'tv', 444, 'Resolution: QLED, 4K Ultra HD (3840x2160) | Refresh Rate: 60 Hertz | 178 Degree wide viewing angle\r\nConnectivity: Dual band Wifi | 2 way Bluetooth | HDMI ports 2.1 x 3 (HDMI 1 supports eARC) to connect personal computer, laptop, set top box, Blu-ray speakers or a gaming console | USB ports 2.0 x 1, 3.0 x 1 to connect hard drives or other USB device\r\nSound: 30 Watts Output', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1694155440745-619--Jabh2L._SL1048_.jpg', 5, 'black', 'acer', 4.2),
(10, 'LG 139 cm (55 inches) 4K Ultra HD Smart OLED TV 55BXPTA...', 'tv', 1322, 'Display backlight technology used by the TV \r\nThe number of display pixels in the TV, usually denoted by the number of horizontal pixels multiplies by number of vertical pixels\r\n', 'https://storage.googleapis.com/fir-auth-1c3bc.appspot.com/1694156089516-71KVQa4N4zL._SL1500_.jpg', 9, 'grey', 'LG', 4.7);