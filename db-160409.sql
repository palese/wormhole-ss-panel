SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `sp_config`;
CREATE TABLE `sp_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(128) NOT NULL,
  `value` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `sp_log`;
CREATE TABLE `sp_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(16) NOT NULL,
  `msg` text NOT NULL,
  `created_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ss_invite_code`;
CREATE TABLE `ss_invite_code` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(128) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--alter table ss_node add column pay_status varchar(127) not null default '0';
DROP TABLE IF EXISTS `ss_node`;
CREATE TABLE `ss_node` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `type` int(3) NOT NULL,
  `server` varchar(128) NOT NULL,
  `method` varchar(64) NOT NULL,
  `custom_method` tinyint(1) NOT NULL DEFAULT '0',
  `traffic_rate` float NOT NULL DEFAULT '1',
  `info` varchar(128) NOT NULL,
  `status` varchar(128) NOT NULL,
  `offset` int(11) NOT NULL DEFAULT '0',
  `sort` int(3) NOT NULL,
  `pay_status` varchar(127) NOT NULL DEFAULT '0',--表示为哪类用户服务
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ss_node_info_log`;
CREATE TABLE `ss_node_info_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) NOT NULL,
  `uptime` float NOT NULL,
  `load` varchar(32) NOT NULL,
  `log_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 词表暂时不用 使用下面的表
DROP TABLE IF EXISTS `ss_node_online_log`;
CREATE TABLE `ss_node_online_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) NOT NULL,
  `online_user` int(11) NOT NULL,
  `log_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 因为ss-manyuser写这个表的时候需要'存在更新,不存在插入', 所以用node_id做键值. @chenjianglong
DROP TABLE IF EXISTS `ss_node_online_log_noid`;
CREATE TABLE `ss_node_online_log_noid` ( 
  `node_id` int(11) NOT NULL,
  `server` varchar(128) NOT NULL,
  `online_user` int(11) NOT NULL,
  `log_time` timestamp(14) NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 记录(port,node)对儿在线状态. 10000个port*50台机器 = 500000条记录
-- 一个用户也许可也持有多个port的. 所以这里记录只是(node,port)对儿为键值
DROP TABLE IF EXISTS `ss_user_node_online_log_noid`;
CREATE TABLE `ss_user_node_online_log_noid` (
  `port` int(11) NOT NULL,  
  `node_id` int(11) NOT NULL,
  `server` varchar(128) NOT NULL,
  `online_status` tinyint(1) NOT NULL,
  `log_time` timestamp(14) NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`port`,`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ss_password_reset`;
CREATE TABLE `ss_password_reset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(32) NOT NULL,
  `token` varchar(128) NOT NULL,
  `init_time` int(11) NOT NULL,
  `expire_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--alter table user add column pay_status varchar(3) not null default '0';
--alter table user add column service_deadline timestamp not null default '1987-09-06 11:00:00';
--alter table user add column next_service_deadline timestamp not null default '1987-09-06 11:00:00';
--alter table user add column purchase_time timestamp not null default '2036-09-06 11:00:00';
--alter table user add column reward tinyint(4) not null default '0';
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `email` varchar(32) NOT NULL,
  `pass` varchar(64) NOT NULL,
  `passwd` varchar(16) NOT NULL,
  `t` int(11) NOT NULL DEFAULT '0',
  `u` bigint(20) NOT NULL,
  `d` bigint(20) NOT NULL,
  `transfer_enable` bigint(20) NOT NULL,
  `port` int(11) NOT NULL,
  `switch` tinyint(4) NOT NULL DEFAULT '1',
  `enable` tinyint(4) NOT NULL DEFAULT '1',
  `type` tinyint(4) NOT NULL DEFAULT '1',
  `last_get_gift_time` int(11) NOT NULL DEFAULT '0',
  `last_check_in_time` int(11) NOT NULL DEFAULT '0',
  `last_rest_pass_time` int(11) NOT NULL DEFAULT '0',
  `reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `invite_num` int(8) NOT NULL DEFAULT '0',
  `is_admin` int(2) NOT NULL DEFAULT '0',
  `ref_by` int(11) NOT NULL DEFAULT '0',
  `expire_time` int(11) NOT NULL DEFAULT '0',
  `method` varchar(64) NOT NULL DEFAULT 'rc4-md5',
  `is_email_verify` tinyint(4) NOT NULL DEFAULT '0',
  `reg_ip` varchar(128) NOT NULL DEFAULT '127.0.0.1',
  `qq` varchar(31) NOT NULL DEFAULT '',
  `pay_status` varchar(3) NOT NULL DEFAULT '0', --0:从未购买过 1:购买过且在有效期内 2:购买过但是已过期
  `service_deadline` timestamp NOT NULL DEFAULT '1987-09-06 11:00:00', --服务截止时间
  `next_service_deadline` timestamp NOT NULL DEFAULT '1987-09-06 11:00:00', --本月服务截止时间
  `purchase_time` timestamp NOT NULL DEFAULT '2036-09-06 11:00:00', --服务购买时间
  `reward` tinyint(4) NOT NULL DEFAULT '0', --表示该用户的推荐者能否获得奖励, 0:不可以 1:可以
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `port` (`port`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user_token`;
CREATE TABLE `user_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(256) NOT NULL,
  `user_id` int(11) NOT NULL,
  `create_time` int(11) NOT NULL,
  `expire_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user_traffic_log`;
CREATE TABLE `user_traffic_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `u` bigint(20) NOT NULL,
  `d` bigint(20) NOT NULL,
  `node_id` int(11) NOT NULL,
  `rate` float NOT NULL,
  `traffic` varchar(32) NOT NULL,
  `log_time` timestamp(14) NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

-- node_load 记载node的累积流量
DROP TABLE IF EXISTS `node_load`;
CREATE TABLE `node_load` (
  `node_id` int(11) NOT NULL,
  `server` varchar(128) NOT NULL,
  `load` bigint(20) NOT NULL,
  `log_time` timestamp(14) NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 
-- donation 记录用户的捐赠
-- insert into donation (user_name, email, amount, donation_time, pay_way) values ('陈江龙', 'ambjlon@163.com', 30, '2016-07-22 11:00:01','支付宝');
-- 注意 执行上面的插入语句时先执行set names utf8, 这是设置mysql的命令行客户端编码. 否则, 页面的展示中中文会乱码. 同样的, select user表的时候也要set names utf8显示出来的中文才不乱吗.
DROP TABLE IF EXISTS `donation`;
CREATE TABLE `donation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `email` varchar(32) NOT NULL,
  `amount` float(6,2) NOT NULL,
  `donation_time` timestamp(14) NOT NULL DEFAULT '1987-09-06 11:00:01',
  `pay_way` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 
--cardnum_passwd 存放代金卡使用情况 涉及交易非常重要.
DROP TABLE IF EXISTS `cardnum_passwd`;
CREATE TABLE `cardnum_passwd` (
  `id` int(11) NOT NULL AUTO_INCREMENT, 
  `cardnum` varchar(15)  CHARACTER SET utf8 NOT NULL,
  `passwd` varchar(31)  CHARACTER SET utf8 NOT NULL,
  `amount` float(6,2) NOT NULL,
  `is_consumed` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`cardnum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- pay_log 存放用户的购买记录
-- insert into pay_log (user_id, pay_time, amount, pay_type, pay_way) values( , , , , );
-- alter table pay_log modify pay_time timestamp(14) NOT NULL DEFAULT '1987-09-06 11:01:00';
DROP TABLE IF EXISTS `pay_log`;
CREATE TABLE `pay_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `pay_time` timestamp(14) NOT NULL DEFAULT '1987-09-06 11:00:01',
  `amount` float(6,2) NOT NULL,
  `pay_type` varchar(31)  CHARACTER SET utf8 NOT NULL, -- A套餐/月付 B套餐/年付等等
  `pay_way` varchar(32) NOT NULL, -- 微信扫码/支付宝扫码(扫码)/代金卡
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 
