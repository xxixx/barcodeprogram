

CREATE TABLE `JAEDAN_REGIST` (
  `NO` int(11) NOT NULL,
  `WORK_ORDER_NO` int(10) NOT NULL,
  `WONDAN_STORE` int(10) NOT NULL,
  `WONDAN_MANAGER_NO` varchar(10) NOT NULL,
  `Y_COUNT` int(10) NOT NULL,
  `MARKS` int(10) NOT NULL,
  `COUNT` int(10) NOT NULL,
  `DEFECTIVE` int(10) NOT NULL,
  `CREATE_DATE` date NOT NULL DEFAULT current_timestamp(),
  `WORK_DATE` date NOT NULL DEFAULT current_timestamp(),
  `REG_ACCOUNT` int(10) NOT NULL,
  `STATE` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `JAEDAN_REGIST`
  ADD PRIMARY KEY (`NO`),
  ADD KEY `WORK_ORDER_NO` (`WORK_ORDER_NO`);


ALTER TABLE `JAEDAN_REGIST`
  MODIFY `NO` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `JAEDAN_REGIST`
  ADD CONSTRAINT `WORK_ORDER_NO` FOREIGN KEY (`WORK_ORDER_NO`) REFERENCES `WORKING_ORDER` (`NO`);


