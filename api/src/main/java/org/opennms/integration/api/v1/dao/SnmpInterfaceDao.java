/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2018 The OpenNMS Group, Inc.
 * OpenNMS(R) is Copyright (C) 1999-2018 The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is a registered trademark of The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * OpenNMS(R) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with OpenNMS(R).  If not, see:
 *      http://www.gnu.org/licenses/
 *
 * For more information contact:
 *     OpenNMS(R) Licensing <license@opennms.org>
 *     http://www.opennms.org/
 *     http://www.opennms.com/
 *******************************************************************************/

package org.opennms.integration.api.v1.dao;

import org.opennms.integration.api.v1.annotations.Consumable;
import org.opennms.integration.api.v1.model.SnmpInterface;

/**
 * Lookup SNMP interfaces.
 *
 * @since 1.0.0
 */
@Consumable
public interface SnmpInterfaceDao {

    Long getSnmpInterfaceCount();

    /**
     * Attempts to find an SNMP interface on a node with the given id
     * that has a ifDescr or ifName matching the given argument.
     *
     * @param nodeId node id
     * @param descrOrName the ifDescr or ifName to match
     * @return a {@link SnmpInterface} or {@code null} if none was found
     */
    SnmpInterface findByNodeIdAndDescrOrName(Integer nodeId, String descrOrName);

}
