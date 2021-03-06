/**
 * Copyright (C) 2011  JTalks.org Team
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */
package org.jtalks.jcommune.service;

import org.jtalks.jcommune.model.entity.Branch;
import org.jtalks.jcommune.service.exceptions.NotFoundException;

import java.util.List;

/**
 * The interface to manipulate with branches
 * 
 * @author Vitaliy Kravchenko
 * @author Kirill Afonin
 * @author Max Malakhov
 */

public interface BranchService extends EntityService<Branch> {
    /**
     * Get branches from section.
     *
     * @param sectionId section id from which we obtain branches
     * @return list of {@code Branch} objects
     * @throws org.jtalks.jcommune.service.exceptions.NotFoundException
     *          when section not found
     */
    List<Branch> getBranchesInSection(long sectionId) throws NotFoundException;

    /**
     * Get number of branches in section.
     *
     * @param sectionId section id where you have to count branches
     * @return number of branches in section
     * @throws org.jtalks.jcommune.service.exceptions.NotFoundException
     *          when branch not found
     */
    int getBranchesInSectionCount(long sectionId) throws NotFoundException;
}