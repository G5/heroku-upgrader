class State

  attr_accessor :joined, :addon_created, :addon_copied, :addon_promoted, :schedule_created, :captured

  def initialize

  end

  def joined
    @joined 
  end

  def addon_created
    @addon_created
  end

  def addon_copied
    @addon_copied
  end

  def addon_promoted
    @addon_promoted
  end

  def schedule_created
    @schedule_created
  end

  def captured
    @captured
  end

end