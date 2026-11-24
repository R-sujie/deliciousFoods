SET NAMES utf8mb4;
INSERT INTO classify_info (id, name, descroiption) VALUES
(1, '家常菜', '适合日常烹饪的简单菜谱');
INSERT INTO sub_classify_info (id, name, description, classifyId) VALUES
(1, '家常素菜', '用常见蔬菜做出下饭菜', 1),
(2, '家常海鲜', '简单易做的鱼虾贝类菜谱', 1);
INSERT INTO foods_menu_info (name, description, tips, subId, fileName, userName, level) VALUES
('蒜香茄子', '茄子切条蒸至软熟。将蒜末与生抽、米醋和少许香油拌匀，淋在茄子上，撒葱花即可。', '家常,素菜', 1, '茄子1601473095219.jpg', '网站示例', 1),
('清蒸鱼', '鱼洗净后放在姜片上，水开后蒸至熟透。倒掉盘中多余水分，加入蒸鱼豉油和葱丝，淋上少量热油。', '清蒸,海鲜', 2, '鱼1601459303467.jpg', '网站示例', 1);
INSERT INTO foods_material_info (name, description, fileName, userName, level) VALUES
('茄子', '适合蒸、炒或炖，烹饪前切块或切条。', '茄子1601473095219.jpg', '网站示例', 1),
('鱼', '适合清蒸或煎煮，烹饪前去鳞并清理干净。', '鱼1601459303467.jpg', '网站示例', 1);
