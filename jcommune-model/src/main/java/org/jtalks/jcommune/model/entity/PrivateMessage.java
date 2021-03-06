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
package org.jtalks.jcommune.model.entity;

import org.joda.time.DateTime;
import org.jtalks.common.model.entity.Entity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;

/**
 * Text message to send from one user to another. <br/>
 * All fields are required.
 * Use the static method PrivateMessage.createNewPrivateMessage()
 * to create new PrivateMessage with current creationDate.
 *
 * @author Pavel Vervenko
 * @author Alexandre Teterin
 */
public class PrivateMessage extends Entity {

    public static final String QUOTE_PREFIX = ">";
    public static final String QUOTE_SEPARATOR = " ";
    public static final String NEW_LINE = System.getProperty("line.separator");

    private final Logger logger = LoggerFactory.getLogger(getClass());
    private DateTime creationDate;
    private User userFrom;
    private User userTo;
    private String title;
    private String body;

    private PrivateMessageStatus status = PrivateMessageStatus.NOT_READ;

    /**
     * Creates the PrivateMessage instance. All fields values are null.
     */
    public PrivateMessage() {
    }

    /**
     * Creates the PrivateMessage with the specified creation date.
     *
     * @param creationDate the pm's creation date
     */
    public PrivateMessage(DateTime creationDate) {
        this.creationDate = creationDate;
    }

    /**
     * Creates a new PrivateMessage with the creationDate initialized with current time.
     *
     * @return newly created PrivateMessage
     */
    public static PrivateMessage createNewPrivateMessage() {
        return new PrivateMessage(new DateTime());
    }

    /**
     * Get the content of the message.
     *
     * @return message's body
     */
    public String getBody() {
        return body;
    }

    /**
     * Set the message's body.
     *
     * @param body content to set
     */
    public void setBody(String body) {
        this.body = body;
    }

    /**
     * Get the creation timestamp of the message.
     *
     * @return creation date
     */
    public DateTime getCreationDate() {
        return creationDate;
    }

    /**
     * Set the creation date and time of the message.
     *
     * @param creationDate datetime to set
     */
    public void setCreationDate(DateTime creationDate) {
        this.creationDate = creationDate;
    }

    /**
     * Get the title of the private message.
     *
     * @return message's title
     */
    public String getTitle() {
        return title;
    }

    /**
     * Set the title to the message.
     *
     * @param title title to set
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * Get the User who send the message.
     *
     * @return sender
     */
    public User getUserFrom() {
        return userFrom;
    }

    /**
     * Set the User who send the message.
     *
     * @param userFrom sender
     */
    public void setUserFrom(User userFrom) {
        this.userFrom = userFrom;
    }

    /**
     * Get the recipient of the message.
     *
     * @return recipient
     */
    public User getUserTo() {
        return userTo;
    }

    /**
     * Set the recipient of the message.
     *
     * @param userTo recipient of the message
     */
    public void setUserTo(User userTo) {
        this.userTo = userTo;
    }

    /**
     * Get message status
     *
     * @return message status
     * @see PrivateMessageStatus
     */
    public PrivateMessageStatus getStatus() {
        return status;
    }

    /**
     * Set message status.
     *
     * @param status message status
     * @see PrivateMessageStatus
     */
    public void setStatus(PrivateMessageStatus status) {
        this.status = status;
    }

    /**
     * Mark message as read.
     */
    public void markAsRead() {
        this.status = PrivateMessageStatus.READ;
    }

    /**
     * @return {@code true} if message is read
     */
    public boolean isRead() {
        return this.status == PrivateMessageStatus.READ;
    }

    /**
     * Mark message as draft.
     */
    public void markAsDraft() {
        this.status = PrivateMessageStatus.DRAFT;
    }

    /**
     * @return {@code true} if message is draft
     */
    public boolean isDraft() {
        return this.status == PrivateMessageStatus.DRAFT;
    }


    /**
     * Prepare title for reply message
     *
     * @return reply title
     */
    public String prepareTitleForReply() {
        //check the "Re: " occurrence in the title of original message and modifying it.
        return title.startsWith("Re: ") ? getTitle() : "Re: " + getTitle();
    }

    /**
     * Prepare body for quote message according to next rules:
     * <ul>
     * <li>each new line beginning with  ">";</li>
     * <li>if there is not ">" or space in the start of the line the space added between ">"  and line.</li>
     * </ul>
     * Quote example:
     * >>> reply
     * >> reply
     * > reply
     *
     * @return quote body
     */

    public String prepareBodyForQuote() {
        StringBuilder bodyBuilder = new StringBuilder();
        BufferedReader inputData = new BufferedReader(new StringReader(getBody()));
        try {
            String line;
            while ((line = inputData.readLine()) != null) {
                if (line.startsWith(QUOTE_PREFIX)) {
                    //create quote line from the quoted line
                    bodyBuilder.append(QUOTE_PREFIX);
                    bodyBuilder.append(line);
                    bodyBuilder.append(NEW_LINE);
                } else {
                    //create quote line from the unquoted line
                    bodyBuilder.append(QUOTE_PREFIX);
                    bodyBuilder.append(QUOTE_SEPARATOR);
                    bodyBuilder.append(line);
                    bodyBuilder.append(NEW_LINE);
                }

            }
        } catch (IOException e) {
            logger.error("Invalid message body data " + e.getMessage());
        }


        return bodyBuilder.toString();
    }


}